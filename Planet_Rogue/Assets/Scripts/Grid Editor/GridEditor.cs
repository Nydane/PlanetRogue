using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class GridEditor : EditorWindow
{
    public static GridEditor instance;
    public GameObject cellPrefab;
    public GameObject parent;
    public GameObject clearParent;
    public int x;
    public int y;
    public float size;


    private void OnGUI()
    {
        EditorGUILayout.BeginHorizontal();
        {
            EditorGUILayout.BeginVertical();
            {
                cellPrefab = EditorGUILayout.ObjectField("Prefab", cellPrefab, typeof(GameObject), false) as GameObject;
                parent = EditorGUILayout.ObjectField("Parent", parent, typeof(GameObject), true) as GameObject;
                clearParent = EditorGUILayout.ObjectField("clearParent", clearParent, typeof(GameObject), true) as GameObject;



                x = (int)EditorGUILayout.Slider("X", x, 1f, 50f);
                y = (int)EditorGUILayout.Slider("Y", y, 1f, 50f);
                size = (int)EditorGUILayout.Slider("Size", size, 1f, 50f);

                GUI.color = Color.green;
                if (GUILayout.Button("Generate Grid"))
                {
                    Generate();
                }

                GUI.color = Color.red;
                if (GUILayout.Button("Clear Grid"))
                {
                    ClearGrid();
                }
            }
            EditorGUILayout.EndVertical();
        }
        EditorGUILayout.EndHorizontal();
    }




    [MenuItem("PlanetRogue/Gridgenerator")]
    public static void Init ()
    {
        if (instance == null)
        {
            instance = GetWindow<GridEditor>();
        }
        instance.minSize = new Vector2(350, 50);
        instance.Show();

    }


    protected void Generate()
    {
        for (int i = 0; i < x; i++)
        {
            for (int j = 0; j < y; j++)
            {
                Instantiate(cellPrefab, new Vector3(i*size, 0, j*size), Quaternion.identity, parent.transform);
            }
        }
    }

    protected void ClearGrid()
    {
        int count = clearParent.transform.childCount;
        for (int i = count-1; i >= 0; i--)
        {
            DestroyImmediate(clearParent.transform.GetChild(i).gameObject);

        }
    }
}
