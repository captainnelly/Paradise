// This file contains all of the trait sources, or all of the things that grant traits.
// Several things such as `type` or `ref(src)` may be used in the ADD_TRAIT() macro as the "source", but this file contains all of the defines for immutable static strings.

/// The item is magically cursed
#define CURSED_ITEM_TRAIT(item_type) "cursed_item_[item_type]"
/// Gives a unique trait source for any given datum
#define UNIQUE_TRAIT_SOURCE(target) "unique_source_[UID(target)]"
/// Trait applied by element
#define ELEMENT_TRAIT(source) "element_trait_[source]"
/// A trait given by a specific status effect (not sure why we need both but whatever!)
#define TRAIT_STATUS_EFFECT(effect_id) "[effect_id]-trait"

// common trait sources
#define GENERIC_TRAIT "generic"
#define MAGIC_TRAIT "magic"
#define CULT_TRAIT "cult"
#define CLOCK_TRAIT "clockwork_cult"
#define INNATE_TRAIT "innate"
#define EAR_DAMAGE "ear_damage"
#define EYE_DAMAGE "eye_damage"

/// cannot be removed without admin intervention
#define ROUNDSTART_TRAIT "roundstart"

// unique trait sources
#define CULT_EYES "cult_eyes"
#define CLOCK_HANDS "clock_hands"
#define PULSEDEMON_TRAIT "pulse_demon"
#define CHANGELING_TRAIT "changeling"
#define VAMPIRE_TRAIT "vampire"
#define NINJA_TRAIT "space-ninja"
/// (B)admins only.
#define ADMIN_TRAIT "admin"

#define CMAGGED "clown_emag"

#define ABSTRACT_ITEM_TRAIT "abstract-item"
#define ABDUCTOR_VEST_TRAIT "abductor-vest"
#define CYBORG_ITEM_TRAIT "cyborg-item"
#define MECHA_EQUIPMENT_TRAIT "mecha-equip"
#define HIS_GRACE_TRAIT "his-grace"
#define CHAINSAW_TRAIT "chainsaw-wield"
#define PYRO_CLAWS_TRAIT "pyro-claws"
#define CONTRACTOR_BATON_TRAIT "contractor-baton"
#define MUZZLE_TRAIT "muzzle"
#define CHRONOSUIT_TRAIT "chrono-suit"
#define SUPERHERO_TRAIT "super-hero"
#define AUGMENT_TRAIT "augment"
#define ANTIDROP_TRAIT "antidrop"

/// A trait given by any status effect
#define STATUS_EFFECT_TRAIT "status-effect"

#define SPECIES_TRAIT "species_trait"

#define CLOTHING_TRAIT "clothing"

#define DNA_TRAIT "dna_trait"

/// Traits applied to a silicon mob by their model.
#define ROBOT_TRAIT "robot_trait"

/// A trait gained from a mob's leap action, like the leaper
#define LEAPING_TRAIT "leaping"

/// Trait given by your current speed
#define SPEED_TRAIT "speed_trait"

/// Trait associated to being cuffed
#define HANDCUFFED_TRAIT "handcuffed_trait"
/// Trait associated to wearing a suit
#define SUIT_TRAIT "suit_trait"

#define NO_GRAVITY_TRAIT "no-gravity"
#define NEGATIVE_GRAVITY_TRAIT "negative-gravity"

/// Sources for TRAIT_IGNORING_GRAVITY
#define IGNORING_GRAVITY_NEGATION "ignoring_gravity_negation"

/// trait associated to being buckled
#define BUCKLED_TRAIT "buckled"

// sources for trait TRAIT_MOVE_FLYING
#define ITEM_BROOM_TRAIT "item_broom_trait"
#define ITEM_GRAV_BOOTS_TRAIT "item_grav_boots_trait"
#define ITEM_JUMP_BOOTS_TRAIT "item_jump_boots_trait"
#define IMPLANT_JUMP_BOOTS_TRAIT "implant_jump_boots_trait"
#define SPELL_LEAP_TRAIT "spell_leap_trait"
#define SPELL_LUNGE_TRAIT "spell_lunge_trait"

