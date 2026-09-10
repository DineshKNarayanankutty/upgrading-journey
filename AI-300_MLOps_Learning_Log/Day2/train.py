import mlflow
import mlflow.sklearn
import joblib

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score


# Load data
data = load_iris()

X = data.data
y = data.target


# Train/test split
X_train, X_test, y_train, y_test = train_test_split(
    X,
    y,
    test_size=0.2,
    random_state=42
)


# Hyperparameters
n_estimators = 200
max_depth = 10


# Train model
model = RandomForestClassifier(
    n_estimators=n_estimators,
    max_depth=max_depth,
    random_state=42
)

model.fit(X_train, y_train)


# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)


# MLflow

mlflow.set_experiment("iris-random-forest")

with mlflow.start_run():

    mlflow.log_param("n_estimators", n_estimators)
    mlflow.log_param("max_depth", max_depth)

    mlflow.log_metric("accuracy", accuracy)

    # Save model
    joblib.dump(model, "model.pkl")

    # Log model file as artifact
    mlflow.log_artifact("model.pkl")

    # Save metrics as artifact
    with open("metrics.txt", "w") as f:
        f.write(f"accuracy={accuracy}\n")

    mlflow.log_artifact("metrics.txt")

print(f"Accuracy: {accuracy}")
