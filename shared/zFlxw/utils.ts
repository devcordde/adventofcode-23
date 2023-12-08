export function readFileLines(path: string): string[] {
  return Deno.readTextFileSync(`${Deno.cwd()}/${path}`).split('\n');
}

/**
 * Chunks a string into fixed-length parts.
 *
 * @param str The string to chunk.
 * @param size The size of the parts.
 * @returns An array of the chunked string.
 */
export function chunkString(str: string, size: number): string[] {
  const numChunks = Math.ceil(str.length / size);
  const chunks = new Array(numChunks);

  for (let i = 0, o = 0; i < numChunks; ++i, o += size) {
    chunks[i] = str.substr(o, size);
  }

  return chunks;
}

/**
 * Replaces multiple whitespaces to one single character.
 *
 * @param str The string where to replace the whitespaces.
 * @param withChar The replacement character.
 * @returns The string with the replaced whitespaces.
 */
export function replaceWhitespaces(str: string, withChar: string): string {
  return str.replace(/\s+/g, withChar);
}
