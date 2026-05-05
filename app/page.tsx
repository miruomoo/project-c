import { createClient } from "@/lib/supabase/server";

export default async function Home() {
  const supabase = await createClient();

  // Verify the Supabase connection. Replace 'your_table' with a real table name
  // once you have created one in your Supabase project.
  const { error } = await supabase.from("your_table").select("count").limit(1);
  const status = error ? `Error: ${error.message}` : "Connected to Supabase ✓";

  return (
    <div className="flex flex-col flex-1 items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex flex-1 w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        <h1 className="text-2xl font-semibold text-black dark:text-white">
          Next.js + Supabase
        </h1>
        <p className="mt-4 text-zinc-600 dark:text-zinc-400">
          Supabase status:{" "}
          <span className={error ? "text-red-500" : "text-green-600"}>
            {status}
          </span>
        </p>
      </main>
    </div>
  );
}
