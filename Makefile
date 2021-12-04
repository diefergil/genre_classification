.ONESHELL:
run_mlflow:
	mlflow run .

.ONESHELL:
run_mlflow_github:
	mlflow run https://github.com/diefergil/genre_classification.git \
            -v 1.0.0 \
            -P hydra_options="main.project_name=remote_execution"

.ONESHELL:
download_data:
	mlflow run . -P hydra_options="main.execute_steps='download,preprocess'"

.ONESHELL:
execute_only_model:
	mlflow run . -P hydra_options="main.execute_steps='random_forest'"

.ONESHELL:
run_multiple_experiments:
	mlflow run . -P hydra_options="-m \
	hydra/launcher=joblib \
	main.execute_steps='random_forest' \
	random_forest_pipeline.random_forest.n_estimators=300,400 \
	random_forest_pipeline.random_forest.max_depth=range(6,10,2)"

# https://hydra.cc/docs/plugins/ax_sweeper/
.ONESHELL:
donwload_model_prod:
	wandb artifact get genre_classification_prod/model_export:prod --root model
# The --root option sets the directory where wandb will save the artifact. 

.ONESHELL:
donwload_csv_test:
	wandb artifact get genre_classification_prod/data_test.csv:latest

.PHONY: model artifacts
predict_batch_test:
	mlflow models predict \
                -t csv \
                -i ./artifacts/data_test.csv:v0/data_test.csv \
                -m model

.PHONY: model
serve_model:
	mlflow models serve -m model &
# & for running in background

