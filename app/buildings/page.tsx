import BuildingCard from "@/app/components/building-card";
import { createClient } from "@/lib/supabase/server";

export default async function BuildingsPage() {
  const supabase = await createClient();

  const { data: buildings, error } = await supabase
    .from("buildings")
    .select("id, building_name, building_type, address, city, description, building_images(storage_path, is_cover)")
    .order("building_name");

  if (error) {
    throw new Error(error.message);
  }

  const buildingsWithCovers = buildings.map((building) => {
    const coverPath =
      building.building_images?.find((img) => img.is_cover)?.storage_path ?? null;
    const cover_image_url = coverPath
      ? supabase.storage.from("building_images").getPublicUrl(coverPath).data.publicUrl
      : null;
    return { ...building, cover_image_url };
  });

  return (
    <div className="flex flex-col flex-1 bg-white">
      <section className="max-w-6xl mx-auto w-full px-6 py-16">
        <h1 className="text-3xl font-semibold text-[#0f0f0f] tracking-tight">
          Buildings
        </h1>
        <p className="mt-2 text-[#6b6b6b] text-sm">
          Rated by tenants. No landlord edits.
        </p>

        {buildingsWithCovers.length === 0 ? (
          <p className="mt-10 text-[#a0a0a0] text-sm">No buildings listed yet.</p>
        ) : (
          <div className="mt-10 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
            {buildingsWithCovers.map((building) => (
              <BuildingCard key={building.id} building={building} />
            ))}
          </div>
        )}
      </section>
    </div>
  );
}
