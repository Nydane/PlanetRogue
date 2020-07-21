using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{

    public float timeBetweenEachSpawn;
    private float timerIncreasing;
    public GameObject enemyPrefab;
    public int numberOfEnemies = 10;
    public float timeBeforeSpawnIncreasing;
    public float timerBeforeSpawn;

    // Start is called before the first frame update
    


    // Update is called once per frame
    void Update()
    {
        timerIncreasing += Time.deltaTime;
        timeBeforeSpawnIncreasing += Time.deltaTime;
        if (numberOfEnemies > 0 && timeBeforeSpawnIncreasing >= timerBeforeSpawn)
        {
            timeBeforeSpawnIncreasing = timerBeforeSpawn;
            if (timerIncreasing > timeBetweenEachSpawn)
            {
                Instantiate(enemyPrefab, transform.position, Quaternion.identity);
                timerIncreasing = 0;
                numberOfEnemies--;
            }
        }

    }
}
