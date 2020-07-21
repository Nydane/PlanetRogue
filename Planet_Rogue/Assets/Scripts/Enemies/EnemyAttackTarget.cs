using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


public class EnemyAttackTarget : MonoBehaviour
{

    public Enemy enemy;
    public float speed;
    public List<GameObject> targets = new List<GameObject>();
    public GameObject finalTarget;
    private int rdm;
    private Rigidbody _rb;
    private GameObject player;
    private GameObject firstTarget;
    private GameObject secondTargert;

    //private NavMeshAgent agent;

    // Start is called before the first frame update
    void Start()
    {
        player = GameObject.Find("Player");
        firstTarget = GameObject.Find("Building_House_1");
        secondTargert = GameObject.Find("Building_House_2");
        targets.Add(player);
        targets.Add(firstTarget);
        targets.Add(secondTargert);

        //agent = GetComponent<NavMeshAgent>();
        _rb = GetComponent<Rigidbody>();
        enemy = GetComponent<Enemy>();
        rdm = Random.Range(0, targets.Count);
        for (int i = 0; i < targets.Count; i++)
        {
            finalTarget = targets[rdm];

        }
    }

    // Update is called once per frame
    void Update()
    {
        if (enemy.isParalyzed == false && enemy.isKnockOut == false && enemy.isGettingAttacked ==false)
        {
            Vector3 moveDirection = finalTarget.transform.position - transform.position;
            //transform.position += moveDirection.normalized * speed * Time.deltaTime;
            //agent.SetDestination(finalTarget.transform.position);
            _rb.MovePosition(transform.position + moveDirection.normalized * speed * Time.deltaTime);

        }

    }
}
