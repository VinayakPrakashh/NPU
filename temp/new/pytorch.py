import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms

# 1. Dataset
transform = transforms.Compose([
    transforms.ToTensor(),
])

train_loader = torch.utils.data.DataLoader(
    datasets.MNIST('.', train=True, download=True, transform=transform),
    batch_size=64, shuffle=True
)

test_loader = torch.utils.data.DataLoader(
    datasets.MNIST('.', train=False, transform=transform),
    batch_size=1000, shuffle=False
)

# 2. Model (Same as your NPU logic)
class SimpleCNN(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv = nn.Conv2d(1, 1, kernel_size=3, stride=1)    # 28x28 -> 26x26
        self.relu = nn.ReLU()
        self.pool = nn.MaxPool2d(2, 2)                          # 26x26 -> 13x13
        self.fc = nn.Linear(13*13, 10)                          # Fully Connected

    def forward(self, x):
        x = self.conv(x)
        x = self.relu(x)
        x = self.pool(x)
        x = x.view(-1, 13*13)
        x = self.fc(x)
        return x

model = SimpleCNN()
optimizer = optim.Adam(model.parameters(), lr=0.001)
loss_fn = nn.CrossEntropyLoss()

# 3. Training loop
for epoch in range(3):  # 3 epochs is enough for demo
    model.train()
    for data, target in train_loader:
        optimizer.zero_grad()
        output = model(data)
        loss = loss_fn(output, target)
        loss.backward()
        optimizer.step()
    print(f"Epoch {epoch+1} completed.")

# 4. Save weights
torch.save(model.state_dict(), "cnn_mnist_weights.pth")
print("Saved trained weights to cnn_mnist_weights.pth")
