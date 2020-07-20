using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WorldCell : MonoBehaviour
{
	public GameObject referenceObject;
	public bool isLava = false;
	//private Renderer cellRenderer;
	//public Material lavaMaterial;

    private void Start()
	{
		referenceObject = GameObject.Find("Player");
	}

	// Update is called once per frame
	void Update()
    {
		Vector3 Ppos = referenceObject.transform.position;
		Ppos.y = transform.position.y;

		if (transform.position.x < referenceObject.transform.position.x - Bounds.bounds.x)
        {
			LoopX();
        }
		else if (transform.position.x > referenceObject.transform.position.x + Bounds.bounds.x)
		{
			LoopX();
		}

		if (transform.position.z < referenceObject.transform.position.z - Bounds.bounds.y)
		{
			LoopZ();
		}
		else if (transform.position.z > referenceObject.transform.position.z + Bounds.bounds.y)
		{
			LoopZ();
		}


		
	}

	private void LoopX()
	{
		float jDirX = Mathf.Sign(referenceObject.transform.position.x - transform.position.x);
		transform.position += new Vector3(Bounds.jumpX * jDirX, 0, 0);
	}

	private void LoopZ ()
	{
		float jDirY = Mathf.Sign(referenceObject.transform.position.z - transform.position.z);
		transform.position += new Vector3(0, 0, Bounds.jumpY * jDirY);

	}

	
	/*public void LavaTile()
    {

		this.cellRenderer.material = lavaMaterial;
		this.gameObject.tag = "LavaTile";
		isLava = true;

	}*/

}
