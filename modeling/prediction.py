def fetch_model():


def prediction(model):

    predictions = model.predict(X_test)
    pred_proba = alg.predict_proba(X_test)[:, 1]