import * as _SecretFunctions from '@/secrets/functions/providers';

const SecretFunctions = _SecretFunctions as Record<string, unknown>;

export default function getSecretFunction<T>(lookup: string, fallback: T): T {
	if (lookup in SecretFunctions) return SecretFunctions[lookup] as T;
	else return fallback;
}
