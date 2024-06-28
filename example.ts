/**
 * Computes the Fibonacci number at a given index using recursion.
 *
 * @param n Index in the Fibonacci sequence. Indexing starts from 0.
 * @returns Fibonacci number at the given index.
 */
const fibonacci = (n: number): number => {
	if (n <= 1)
		return n;
	else
		return fibonacci(n - 1) + fibonacci(n - 2);
}
