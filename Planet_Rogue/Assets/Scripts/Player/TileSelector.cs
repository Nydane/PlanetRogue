using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileSelector : MonoBehaviour
{
    // Start is called before the first frame update

    public Material newCellSelectorMaterial;
    public Material oldMaterial;
    public Material lavaMaterial;
    public Renderer cellRenderer;

    private void Start()
    {
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.CompareTag("Ground"))
        {
            if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = newCellSelectorMaterial;

            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.transform.CompareTag("Ground"))
        {
            if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = oldMaterial;
            }
        }
    }


    private void OnTriggerStay(Collider other)
    {
        if (other.transform.CompareTag("Ground"))
        {
            if (Input.GetKeyUp(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = oldMaterial;
            }
            else if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material =  newCellSelectorMaterial;
                
            }
            


            if (Input.GetKey(KeyCode.A) && Input.GetMouseButton(1) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = oldMaterial;
            }

           
            if (Input.GetKey(KeyCode.A) && Input.GetMouseButton(0))
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = lavaMaterial;
                other.GetComponent<WorldCell>().isLava = true;
                
            }
        }
    }
}
