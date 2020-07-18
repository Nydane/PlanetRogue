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
  

    private Vector3 moveVector;
    private float horizontalMovement;
    private float verticalMovement;
     
    [SerializeField]
    private bool _canMove = true;
    [SerializeField]
    private bool _canRotate = true;
    public bool useController;

    [Header("PlayerInfo")]
    public Rigidbody rb;
    public GameObject render;
    public Animator animator;
    private Camera mainCamera;
    public GunController gunController;

    [Header("CellSelector")]
    public GameObject cellSelector;
    public Renderer cellMaterial;
    private float rayLength = 5f;
    public Material startCellSelectorMaterial;
    public Material newCellSelectorMaterial;


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
        mainCamera = FindObjectOfType<Camera>();
    }

    // Update is called once per frame
    void Update()
    {

        //Raycast pour le selector de cell
       /* Ray downRay = new Ray(cellSelector.transform.position, Vector3.down * rayLength);
        Debug.DrawRay(cellSelector.transform.position, Vector3.down * rayLength);

        if (Input.GetKeyDown(KeyCode.A))
        {
            if (Physics.Raycast(downRay, out RaycastHit hitInfo, rayLength))
            {
                if (hitInfo.collider.tag == "Ground")
                {
                    cellMaterial = hitInfo.collider.GetComponent<Renderer>();
                    cellMaterial.material = newCellSelectorMaterial;
                }
            }
        }
        if (Input.GetKeyUp(KeyCode.A))
        {
            if (Physics.Raycast(downRay, out RaycastHit hitInfo, rayLength))
            {
                if (hitInfo.collider.tag == "Ground")
                {
                    cellMaterial = hitInfo.collider.GetComponent<Renderer>();
                    cellMaterial.material = startCellSelectorMaterial;
                }
            }
        }*/


      

        // logique pour immune après avoir pris des dégâts
        if (tookDamage)
        {
            Immunity(immunityTimer);
        }

        //Death logique
        if (playerDead == true && Input.GetKeyDown(KeyCode.JoystickButton0))
        {
            Time.timeScale = 1;
        }

        // Identification des mouvements
        horizontalMovement = Input.GetAxisRaw("Horizontal");
        verticalMovement = Input.GetAxisRaw("Vertical");

        moveVector = new Vector3(horizontalMovement, 0f, verticalMovement);

        

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

        // rotatewithMouse
        if (!useController)
        {
            Ray cameraRay = mainCamera.ScreenPointToRay(Input.mousePosition);
            Plane groundPlane = new Plane(Vector3.up, Vector3.zero);
            float rayLength;

            if (groundPlane.Raycast(cameraRay, out rayLength))
            {
                Vector3 pointToLook = cameraRay.GetPoint(rayLength);
                transform.LookAt(new Vector3(pointToLook.x, transform.position.y, pointToLook.z));
            }

            
        }

        //rotatewithcontroller
        if (useController)
        {
            Vector3 playerDirection = Vector3.right * Input.GetAxisRaw("RHorizontal") + Vector3.forward * -Input.GetAxisRaw("RVertical");
            if (playerDirection.sqrMagnitude > 0)
            {
                transform.rotation = Quaternion.LookRotation(playerDirection, Vector3.up);
            }

            if (Input.GetAxisRaw("RTrigger") > 0)
            {
                gunController.isFiring = true;
            }

            if (Input.GetAxisRaw("RTrigger") <= 0)
            {
                gunController.isFiring = false;
            }
        }


        // Mouse clique gauche
        if (Input.GetMouseButtonDown(0))
        {
            gunController.isFiring = true;
        }
        if (Input.GetMouseButtonUp(0))
        {
            gunController.isFiring = false;
        }
        if (Input.GetKey(KeyCode.A))
        {
            gunController.isFiring = false;

        }


        // TOUCHE B : DASH
        if (Input.GetKeyUp(KeyCode.Joystick1Button1) && _canDash)
        {
            StartCoroutine(Dash(dashVelocity));
            
        }

        
    }




    private void FixedUpdate()
    {
        if (_canMove)
        {
            //rb.MovePosition(rb.position + moveVector * _playerSpeed * Time.deltaTime);
            transform.position += moveVector.normalized * _playerSpeed * Time.deltaTime;

        }
        else
        {
            //rb.MovePosition(rb.position + Vector3.zero * Time.deltaTime);
            transform.position += Vector3.zero * Time.deltaTime;

        }
        // ce qui fait bouger le personnages
    }


    IEnumerator Dash(float dashPower)
    {
        
        
        if (verticalMovement ==0 && horizontalMovement == 0)
        {
            rb.velocity = moveVector * dashPower;
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

        if (collision.transform.tag == "Ground")
        {
            if (collision.transform.GetComponent<WorldCell>().isLava == true)
            {

                if (!isImmune)
                {
                    DamageTaken(20);

                }

            }
        }

    }
    
    private void OnCollisionStay(Collision collision)
    {
        if (collision.transform.tag == "Ground")
        {
            if (collision.transform.GetComponent<WorldCell>().isLava == true)
            {
                
                if (!isImmune)
                {
                    DamageTaken(20);

                }

            }
        }
    }



}

