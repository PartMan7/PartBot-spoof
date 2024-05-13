import * as SecretFunctions from 'secrets/functions/providers';

export default function getSecretFunction<T> (lookup: string, fallback: T): T {
	if (lookup in SecretFunctions) return SecretFunctions[lookup];
	else return fallback;
}
