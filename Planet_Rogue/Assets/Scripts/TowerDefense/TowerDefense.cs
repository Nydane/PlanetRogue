using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TowerDefense : MonoBehaviour
{
    [Header("Health")]
    public int currentBuildingHealth;
    public int maxBuildingHealth = 1000;
    public HealthBar healthBar;

    // Start is called before the first frame update
    void Start()
    {
        currentBuildingHealth = maxBuildingHealth;
        healthBar.SetMaxHealth(currentBuildingHealth);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void BuildingTakeDamage (int Damage)
    {
        currentBuildingHealth -= Damage;
        healthBar.SetHealth(currentBuildingHealth);


        if (currentBuildingHealth <= 0)
        {

            DeadBuilding();
        }
    }

    public void DeadBuilding ()
    {
        Debug.Log("The Building is Destroyed!!!");
        gameObject.SetActive(false);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Enemy")
        {
            BuildingTakeDamage(20);
        }
    }

}
