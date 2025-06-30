import numpy as np
import matplotlib.pyplot as plt
import torch
from torchvision.datasets import MNIST
import torchvision.transforms as transforms

# Load real MNIST test digit
mnist = MNIST('.', train=False, transform=transforms.ToTensor())
img_tensor, label = mnist[4]  # change index for different images
image = img_tensor.numpy()[0]  # (1, 28, 28) → (28, 28)

plt.imshow(image, cmap='gray')
plt.title(f"True Label: {label}")
plt.axis('off')
plt.show()

# Step 1: Convolution layer
def conv2d(image, kernel):
    kh, kw = kernel.shape
    h, w = image.shape
    output = np.zeros((h - kh + 1, w - kw + 1))
    for i in range(output.shape[0]):
        for j in range(output.shape[1]):
            region = image[i:i+kh, j:j+kw]
            output[i, j] = np.sum(region * kernel)
    return output

# Step 2: ReLU
def relu(x):
    return np.maximum(0, x)

# Step 3: Max Pooling (2x2, stride=2)
def maxpool2d(feature_map):
    h, w = feature_map.shape
    output = np.zeros((h // 2, w // 2))
    for i in range(0, h, 2):
        for j in range(0, w, 2):
            output[i//2, j//2] = np.max(feature_map[i:i+2, j:j+2])
    return output

# Step 4: Fully Connected Layer
def fully_connected(flattened_input, weights, biases):
    logits = np.dot(flattened_input, weights) + biases
    print(f"\nLogits (output of FC layer):\n{logits}")
    return logits

# Step 5: Prediction
def predict(logits):
    pred = np.argmax(logits)
    print(f"\nPredicted digit: {pred}")
    return pred

# === Load trained weights from PyTorch .pth ===
state_dict = torch.load("cnn_mnist_weights.pth", map_location='cpu')

# Insert trained Conv2D kernel manually
kernel = np.array([
    [0.6246396,  0.36063653, 0.5131115],
    [0.1736183,  0.7053251,  0.82171136],
    [0.31490964, 0.32573316, 0.59068763]
])
print("Convolution Kernel:\n", kernel)

# Extract FC layer weights and bias
fc_weights = state_dict['fc.weight'].numpy().T  # shape (169, 10)
print(fc_weights)
fc_biases = state_dict['fc.bias'].numpy()       # shape (10,)

# === Forward pass through each layer ===
conv_out = conv2d(image, kernel)
plt.imshow(conv_out, cmap='viridis')
plt.title("After Convolution")
plt.colorbar()
plt.show()

relu_out = relu(conv_out)
plt.imshow(relu_out, cmap='viridis')
plt.title("After ReLU")
plt.colorbar()
plt.show()

pooled_out = maxpool2d(relu_out)
plt.imshow(pooled_out, cmap='viridis')
plt.title("After MaxPooling")
plt.colorbar()
plt.show()

flattened = pooled_out.flatten()
print(f"\nFlattened output shape: {flattened.shape}")
print(f"First 10 values of flattened output:\n{flattened[:10]}")

logits = fully_connected(flattened, fc_weights, fc_biases)
digit = predict(logits)
