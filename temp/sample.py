import torch
import torch.nn as nn
import numpy as np
import matplotlib.pyplot as plt

# --- 1. Generate synthetic data (replace with real dataset later) ---
def generate_data(seq_len=1000):
    time = np.arange(seq_len)
    current = np.random.normal(1.0, 0.2, seq_len)
    voltage = 3.7 - 0.01 * np.cumsum(current)
    temperature = 25 + np.random.normal(0, 0.5, seq_len)
    soc = 1.0 - np.cumsum(current) / np.max(np.cumsum(current))  # SoC goes from 1 to 0
    data = np.stack([current, voltage, temperature], axis=1)
    return data.astype(np.float32), soc.astype(np.float32)

X_raw, y_raw = generate_data()

# Normalize inputs
X = (X_raw - X_raw.mean(axis=0)) / X_raw.std(axis=0)
y = y_raw.reshape(-1, 1)

# Convert to PyTorch
X_tensor = torch.from_numpy(X).unsqueeze(1)  # shape: (T, 1, 3)
y_tensor = torch.from_numpy(y).unsqueeze(1)  # shape: (T, 1, 1)

# --- 2. Define LSTM Model ---
class SoCLSTM(nn.Module):
    def __init__(self, input_size=3, hidden_size=16, output_size=1):
        super(SoCLSTM, self).__init__()
        self.lstm = nn.LSTM(input_size, hidden_size, batch_first=False)
        self.fc = nn.Linear(hidden_size, output_size)
        self.sigmoid = nn.Sigmoid()  # To scale between 0 and 1

    def forward(self, x):
        out, _ = self.lstm(x)
        out = self.fc(out)
        out = self.sigmoid(out)
        return out

model = SoCLSTM()

# --- 3. Train the model ---
criterion = nn.MSELoss()
optimizer = torch.optim.Adam(model.parameters(), lr=0.01)

num_epochs = 200
for epoch in range(num_epochs):
    model.train()
    output = model(X_tensor)
    loss = criterion(output, y_tensor)
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    if epoch % 20 == 0:
        print(f"Epoch {epoch}, Loss: {loss.item():.5f}")

# --- 4. Plot predictions ---
model.eval()
with torch.no_grad():
    predicted = model(X_tensor).squeeze().numpy()

plt.figure(figsize=(10, 4))
plt.plot(y_raw, label="True SoC")
plt.plot(predicted, label="Predicted SoC")
plt.legend()
plt.xlabel("Time Step")
plt.ylabel("SoC")
plt.title("SoC Estimation using LSTM")
plt.grid()
plt.show()
