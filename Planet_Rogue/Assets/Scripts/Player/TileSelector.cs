using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileSelector : MonoBehaviour
{
    // Start is called before the first frame update

    private Renderer cellMaterial;
    public Material newCellSelectorMaterial;
    private Material oldMaterial;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Ground")
        {
            if (Input.GetKeyDown(KeyCode.A))
            {
                cellMaterial = other.GetComponent<Renderer>();
                oldMaterial = cellMaterial.material;
                cellMaterial.material = newCellSelectorMaterial;

            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Ground")
        {

            cellMaterial = other.GetComponent<Renderer>();
            
            cellMaterial.material = oldMaterial;

        }
    }
}
