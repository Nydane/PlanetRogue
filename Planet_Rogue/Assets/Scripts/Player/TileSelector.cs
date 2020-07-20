using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileSelector : MonoBehaviour
{
    // Start is called before the first frame update

    public Material grassMaterial;
    public Material grassSelected;
    public Material waterMaterial;
    public Material waterSelected;
    public Material lavaMaterial;
    public Renderer cellRenderer;
    private GameObject ressources;

    private void Start()
    {
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.transform.CompareTag("GrassTile"))
        {
            if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = grassSelected;

            }
        }

        if (other.transform.CompareTag("WaterTile"))
        {
            if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = waterSelected;

            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.transform.CompareTag("GrassTile"))
        {
            if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = grassMaterial;

            }
        }

        if (other.transform.CompareTag("WaterTile"))
        {
            if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = waterMaterial;

            }
        }
    }

    [System.Obsolete]
    private void OnTriggerStay(Collider other)
    {
        if (other.transform.CompareTag("GrassTile"))
        {
            if (!Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = grassMaterial;
            }
            else if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = grassSelected;
            }

            if (Input.GetKey(KeyCode.A) && Input.GetMouseButton(1) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = grassMaterial;
            }

            if (Input.GetKey(KeyCode.A) && Input.GetMouseButton(0))
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = lavaMaterial;
                other.GetComponent<WorldCell>().isLava = true;
                other.gameObject.tag = "LavaTile";
               // ressources = other.gameObject.transform.Find("crystals");
               // Destroy(ressources.gameObject);


            }
        }

        if (other.transform.CompareTag("WaterTile"))
        {
            if (!Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = waterMaterial;
            }
            else if (Input.GetKey(KeyCode.A) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = waterSelected;
            }

            if (Input.GetKey(KeyCode.A) && Input.GetMouseButton(1) && other.GetComponent<WorldCell>().isLava == false)
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = waterMaterial;
            }

            if (Input.GetKey(KeyCode.A) && Input.GetMouseButton(0))
            {
                cellRenderer = other.GetComponent<Renderer>();
                cellRenderer.material = lavaMaterial;
                other.GetComponent<WorldCell>().isLava = true;
                other.gameObject.tag = "LavaTile";



            }
        }
    }
}




