using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;



public class Player : MonoBehaviour
{
    public static Player playerInstance;

    [Header("Health")]
    public int health;
    public int maxHealth = 100;
    public HealthBar healthBar;
    public float forwardRayCastLength = 2f;

    [Header("Immune")]
    public float cooldownImmunityTimer = 0f;
    public float immunityTimer = 1f;
    public bool isImmune = false;

    [Header("Damage")]
    public bool tookDamage = false;

    [Header("Death")]
    public bool playerDead;
    public GameObject endImage;

    [Header("Mouvements")]
    [SerializeField]
    public float _playerSpeed = 5f;
    [SerializeField]
    public float playerMaxSpeed = 20f;
    [SerializeField]
    private float _playerMinSpeed = 5f;
    [SerializeField]
    private float _playerSpeedIncr = 0.90f;
    [SerializeField]
    private float _playerSpeedDecr = 0.90f;
    [SerializeField]
    private float _airControlRatio = 0.5f;

    public Vector3 moveVector;
    public Vector3 moveVectorJump;
    public Vector3 playerDirection;
    public float horizontalMovement;
    public float verticalMovement;
    private Vector3 lastDir;
     
    [SerializeField]
    private bool _canMove = true;
    [SerializeField]
    private bool _canRotate = true;
    public bool _isCarrying = false;

    [Header("PlayerInfo")]
    public Rigidbody rb;
    public GameObject render;
    public Animator animator;
    public Renderer arms;

      
    [Header("Dash")]
    public float timeBetweenDash = 2f;
    [SerializeField]
    private bool _canDash = true;
    [SerializeField]
    public float dashVelocity = 10f;

   




    // Start is called before the first frame update
    void Start()
    {
        rb = transform.GetComponent<Rigidbody>();
        playerInstance = this;
        health = maxHealth;
        //basicCollider = GetComponentInChildren<EnemyDetectorBasic>();
    }

    // Update is called once per frame
    void Update()
    {

        
        // logique pour immune après avoir pris des dégâts

        if (tookDamage)
        {
            Immunity(immunityTimer);

        }

        //Death logique
        if (playerDead == true && Input.GetKeyDown(KeyCode.JoystickButton0))
        {

            Time.timeScale = 1;
            SceneManager.LoadScene("Scene_Arena");
            EnemyDetectorBear.EnemiesDetectedBear.Clear();
            PickUpDetector.pickUpDetectorList.Clear();

        }

       



        


        // Identification des mouvements
        horizontalMovement = Input.GetAxisRaw("Horizontal");
        verticalMovement = Input.GetAxisRaw("Vertical");


        moveVector = new Vector3(horizontalMovement, 0f, verticalMovement);

       
      if (_canMove)
      {
        rb.MovePosition(rb.position + moveVector * _playerSpeed * Time.deltaTime);
      }
      else
      {
      rb.MovePosition(rb.position + Vector3.zero * Time.deltaTime);
      }
            // ce qui fait bouger le personnages
        


        //direction du personnage : on fait rotate le render et non le player en tant que tel

        if ((horizontalMovement != 0 || verticalMovement != 0) && _canRotate)
        {
            render.transform.rotation = Quaternion.LookRotation(moveVector);

            if (horizontalMovement < 0)
            {
                playerDirection = new Vector3(Input.GetAxis("Horizontal"), 0f, 0f).normalized;

            }
            if (horizontalMovement > 0)
            {
                playerDirection = new Vector3(Input.GetAxis("Horizontal"), 0f, 0f).normalized;

            }
            if (verticalMovement < 0)
            {
                playerDirection = new Vector3(0f, 0f, Input.GetAxis("Vertical")).normalized;

            }
            if (verticalMovement > 0)
            {
                playerDirection = new Vector3(0f, 0f, Input.GetAxis("Vertical")).normalized;

            }

            if (verticalMovement > 0 && horizontalMovement > 0)
            {
                playerDirection = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical")).normalized;

            }
            if (verticalMovement > 0 && horizontalMovement < 0)
            {
                playerDirection = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical")).normalized;

            }
            if (verticalMovement < 0 && horizontalMovement > 0)
            {
                playerDirection = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical")).normalized;

            }
            if (verticalMovement < 0 && horizontalMovement < 0)
            {
                playerDirection = new Vector3(Input.GetAxis("Horizontal"), 0f, Input.GetAxis("Vertical")).normalized;

            }
        }


        // speed Incr
        if (horizontalMovement > 0)
        {
            if (_playerSpeed < playerMaxSpeed)
            {
                _playerSpeed += (Time.deltaTime * _playerSpeedIncr);
                if (_playerSpeed > playerMaxSpeed)
                {
                    _playerSpeed = playerMaxSpeed;
                }
            }

        }

        if (horizontalMovement < 0)
        {
            if (_playerSpeed < playerMaxSpeed)
            {
                _playerSpeed += (Time.deltaTime * _playerSpeedIncr);
                if (_playerSpeed > playerMaxSpeed)
                {
                    _playerSpeed = playerMaxSpeed;
                }
            }

        }


        if (verticalMovement < 0)
        {
            if (_playerSpeed < playerMaxSpeed)
            {
                _playerSpeed += (Time.deltaTime * _playerSpeedIncr);
                if (_playerSpeed > playerMaxSpeed)
                {
                    _playerSpeed = playerMaxSpeed;
                }
            }

        }

        if (verticalMovement > 0)
        {
            if (_playerSpeed < playerMaxSpeed)
            {
                _playerSpeed += (Time.deltaTime * _playerSpeedIncr);
                if (_playerSpeed > playerMaxSpeed)
                {
                    _playerSpeed = playerMaxSpeed;
                }
            }

        }
        // speed decrease
        if (horizontalMovement == 0 && verticalMovement == 0)
        {
            _playerSpeed *= _playerSpeedDecr;   // speedDecr entre 0 et 1
            if (_playerSpeed < _playerMinSpeed)
            {
                _playerSpeed = _playerMinSpeed;
            }
        }



        

        // TOUCHE B : DASH
        if (Input.GetKeyUp(KeyCode.Joystick1Button1) && _canDash)
        {
            StartCoroutine(Dash(dashVelocity));

            
        }

        
    }

   

    

    

    IEnumerator Dash(float dashPower)
    {
        
        
        if (verticalMovement ==0 && horizontalMovement == 0)
        {
            rb.velocity = playerDirection * dashPower;
        }
        else rb.velocity = new Vector3(horizontalMovement, 0f, verticalMovement) * dashPower;

        _canDash = false;

        yield return new WaitForSeconds(timeBetweenDash);

        _canDash = true;

    }

    

    public void DamageTaken (int damage)
    {
        health -= damage;
        healthBar.SetHealth(health);
        tookDamage = true;

        if (health <= 0)
        {
            Die();
        }
    }

    void Die()
    {
        endImage.SetActive(true);

        Time.timeScale = 0;
        playerDead = true;
        //this.enabled = false;
    }

    void Immunity (float immunityTimer)
    {
        isImmune = true;
        cooldownImmunityTimer += Time.deltaTime;
        if (cooldownImmunityTimer >= immunityTimer)
        {
            cooldownImmunityTimer = 0;
            isImmune = false;
            tookDamage = false;

        }

    }


    private void OnCollisionEnter(Collision collision)
    {
        if (collision.transform.tag == "Enemy")
        {

            if (!isImmune)
            {
                DamageTaken(10);

            }
        }
    }

}

