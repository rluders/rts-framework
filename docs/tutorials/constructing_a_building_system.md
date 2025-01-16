# Constructing a Building

## **Objective**

Create a system where the player can:

1. Select a worker unit.
2. Issue a command to construct a building at a specified location.
3. Manage construction progress, completion, and any dependencies.

### **Step 1: Setting Up the Root Scene**

1. **Create the Root Scene**:
    - Create a new `Node3D` scene and save it as `MainScene.tscn`.
    - Add the following child nodes:
        - **DirectionalLight3D**: For consistent global lighting.
        - **Camera3D**: Position it for a top-down RTS perspective.
        - **PlaneMesh**: To act as the ground. Set its size and material as needed for your environment.
    
    **Screenshot Suggestion**: Show the scene hierarchy with `MainScene`, light, camera, and plane nodes.
    
2. **Environment Settings**:
    - Configure the environment for a basic 3D appearance:
        - In the `WorldEnvironment` node, add a default environment resource.
        - Adjust ambient lighting and background to your preference.
    
    **Screenshot Suggestion**: Show the environment configuration.
    

### **Step 2: Adding RTSController and Managers**

1. **Add RTSController**:
    - Add an `RTSController` node to the `MainScene`.
    - Attach the `RTSController.gd` script to it.
2. **Add Managers**:
    - Add the following child nodes under the `RTSController`:
        - `SelectionManager`: Attach `SelectionManager.gd`.
        - `CommandManager`: Attach `CommandManager.gd`.
        - `ConstructionManager`: Attach `ConstructionManager.gd`.
    
    **Screenshot Suggestion**: Show the `RTSController` with its child managers in the hierarchy.
    

### **Step 3: Adding BuildingEntity Scene**

1. **Create the BuildingEntity Scene**:
    - Create a new scene with a `Node3D` as the root.
    - Add the following child nodes:
        - **MeshInstance3D**: For the building's visual representation.
        - **QueueComponent**: For managing production (e.g., units from the building).
        - **DamageableComponent**: Optional, for destructible buildings.
    
    **Screenshot Suggestion**: Show the `BuildingEntity` scene hierarchy.
    
2. **Save and Configure**:
    - Save the scene as `BuildingEntity.tscn`.
    - Add the scene to a folder like `resources/building_scenes`.

### **Step 4: Implementing Construction Logic**

1. **Configure ConstructionManager**:
    - Ensure the `ConstructionManager` script handles construction requests:
        - Spawning the `BuildingEntity` at the specified position.
        - Using worker units (if provided) to handle construction progress.

```gdscript
func start_construction(building_scene: PackedScene, target_position: Vector3, worker: UnitEntity = null):
    if worker:
        worker.state_machine.transition_to("build")
    else:
        var building_instance = building_scene.instance()
        building_instance.global_transform.origin = target_position
        get_tree().current_scene.add_child(building_instance)
        emit_signal("construction_started", building_scene.resource_path, null)
        emit_signal("construction_completed", building_instance)

```

1. **Worker Logic**:
    - Ensure the `UnitEntity` includes a `BuildState` for constructing buildings:
        - Adjust construction progress over time.
        - Transition back to `IdleState` when the building is complete.

### **Step 5: Testing and Enhancements**

1. **Test Construction**:
    - Run the game.
    - Select a worker unit and issue a build command for a building.
    - Verify that the building spawns and transitions to the completed state.
2. **Enhancements**:
    - Add a placement preview for buildings before finalizing their position.
    - Add construction animations or effects during the building process.