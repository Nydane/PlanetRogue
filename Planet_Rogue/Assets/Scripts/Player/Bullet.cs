using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float speed = 20f;

    public float timeAliveMax = 5f;
    public float timeAlive;

    // Start is called before the first frame update
    void Start()
    {
       

    }
    private void Update()
    {
        transform.Translate(Vector3.forward* speed *Time.deltaTime);
        
        timeAlive += Time.deltaTime;
        if (timeAlive > timeAliveMax)
        {
            Destroy(gameObject);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Enemy")
        {

            Destroy(gameObject);
        }

        
    }
}
