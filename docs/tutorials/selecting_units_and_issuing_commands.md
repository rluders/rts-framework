# Selecting Units and Issuing Commands

## Objective

Create a system where the player can:

1. Select units using a drag-selection or single-click.
2. Issue a movement command to selected units by clicking on the ground.

### **Step 1: Setting Up the Scene**

1. **Add RTSController**:
    - Create a `RTSController` node in your scene.
    - Attach the `RTSController.gd` script to it.
    
    **Screenshot Suggestion**: Show the main scene with the `RTSController` node added and its inspector panel.
    
2. **Add Managers**:
    - As children of the `RTSController`, add:
        - A `SelectionManager` node and attach the `SelectionManager.gd` script.
        - A `CommandManager` node and attach the `CommandManager.gd` script.
    
    **Screenshot Suggestion**: Show the `RTSController` with `SelectionManager` and `CommandManager` as child nodes.
    

### **Step 2: Adding Units to the Scene**

1. **Create UnitEntity Scene**:
    - Create a new `UnitEntity` scene with:
        - A `Node3D` as the root (with `UnitEntity.gd` attached).
        - A `Sprite3D` for the unit’s visual representation.
        - A `SelectableComponent` as a child of the root.
    
    **Screenshot Suggestion**: Show the `UnitEntity` scene hierarchy in the editor.
    
2. **Place Units in the World**:
    - Instance several `UnitEntity` scenes and position them in your game world.
    - Group them under a `Units` node for organization.
    - Ensure each unit has the `SelectableComponent` and is added to the `"units"` group.
    
    **Screenshot Suggestion**: Show units scattered in the world with the `"units"` group assigned in the inspector.
    

### **Step 3: Configuring Selection**

1. **Configure SelectionManager**:
    - In the `SelectionManager` script, ensure `raycast_manager` is correctly assigned to the **Raycaster** node.
    - Add a `ColorRect` to the UI layer as the selection box and link it to the `selection_box` property in the inspector.
    
    **Screenshot Suggestion**: Show the `SelectionManager` with its `raycast_manager` and `selection_box` properties configured.
    
2. **Input Mapping**:
    - Add input actions in the `Input Map` for:
        - `select`: For left mouse button.
        - `command`: For right mouse button.
    
    **Screenshot Suggestion**: Show the input mappings in the project settings.
    
3. **Enable Selection Visualization**:
    - Ensure each unit’s `SelectableComponent` is configured with a `Sprite3D` and a shader for the selection ring.
    
    **Screenshot Suggestion**: Show the `SelectableComponent` setup in the unit’s scene.
    

### **Step 4: Configuring Commands**

1. **Raycaster Setup**:
    - Add a `Raycaster` node to the main scene and attach the `Raycaster.gd` script.
    - Configure the raycaster’s collision layers to detect ground surfaces and units.
    
    **Screenshot Suggestion**: Show the `Raycaster` node configuration in the inspector.
    
2. **Implement Commands**:
    - In the `CommandManager` script:
        - Ensure the `issue_command` method supports `move` commands.
        - Connect the selected units to their `StateMachine` and transition to `MoveState` when a command is issued.
    
    **Screenshot Suggestion**: Highlight the `issue_command` logic in the `CommandManager.gd` script.
    

### **Step 5: Testing the System**

1. **Test Selection**:
    - Run the game and test dragging the selection box or clicking on individual units to select them.
    - Verify that selected units visually highlight using the `SelectableComponent`.
    
    **Screenshot Suggestion**: Capture the drag-selection in action, highlighting units in the selection area.
    
2. **Test Commands**:
    - After selecting units, right-click on the ground to issue a move command.
    - Verify that the units move to the target position using `NavigationAgent3D`.
    
    **Screenshot Suggestion**: Capture units moving toward the clicked position.
    

### **Step 6: Debugging and Enhancements**

1. **Debug Logs**:
    - Add debug prints in the `RTSController`, `SelectionManager`, and `CommandManager` to ensure the correct units are selected and commands are issued.
2. **Enhancements**:
    - Add command feedback, such as a visual marker at the target position.
    - Expand the command system to include additional commands like attack or patrol.