﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{

    public float TimeBetweenEachSpawn;
    private float timerIncreasing;
    public GameObject enemyPrefab;
    public int numberOfEnemies = 10;

    // Start is called before the first frame update
    


    // Update is called once per frame
    void Update()
    {
        timerIncreasing += Time.deltaTime;
        if (numberOfEnemies >= 0)
        {
            if (timerIncreasing > TimeBetweenEachSpawn)
            {
                Instantiate(enemyPrefab, transform.position, Quaternion.identity);
                timerIncreasing = 0;
                numberOfEnemies--;
            }
        }

    }
}
