using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Bounds : MonoBehaviour
{

	public static Vector2 bounds;
	public float x;
	public float y;
	public static float jumpX;
	public static float jumpY;
	public  float _jumpX;
	public  float _jumpY;

	private void Start()
	{
		bounds = new Vector2(x, y);
		jumpX = _jumpX;
		jumpY = _jumpY;
	}

    private void OnDrawGizmos()
    {
		Gizmos.DrawLine(transform.position + new Vector3(x, 0, y), transform.position + new Vector3(x, 0, -y)) ;
		Gizmos.DrawLine(transform.position + new Vector3(x, 0, -y), transform.position + new Vector3(-x, 0, -y));
		Gizmos.DrawLine(transform.position + new Vector3(-x, 0, -y), transform.position + new Vector3(-x, 0, y));
		Gizmos.DrawLine(transform.position + new Vector3(-x, 0, y), transform.position + new Vector3(x, 0, y));
	}
}

	