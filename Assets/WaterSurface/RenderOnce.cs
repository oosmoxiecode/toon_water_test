using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderOnce : MonoBehaviour {

	public GameObject cube;
	public GameObject sphere;

	public GameObject cubeObject;
	public GameObject cylinderObject;
	public Transform container;

	// Use this for initialization
	void Start () {

		//gameObject.SetActive(true);
		spawnObjects();

		renderOnce();

	}

	void renderOnce () {

		gameObject.GetComponent<Camera>().Render();

		Debug.Log("Render Once!");

		gameObject.GetComponent<UnityStandardAssets.ImageEffects.Blur>().enabled = false;
		scaleDown();

		gameObject.GetComponent<Camera>().Render();

		Debug.Log("Render Twice!");

		gameObject.SetActive(false);


	}

	void scaleDown () {

		foreach (Transform child in transform) {
			//child.gameObject.renderer.enabled = false;
			child.localScale *= 0.6f;
		}
	}

	void spawnObjects () {

		float multiplier = 0.9f;

		for(int x=0; x<10; ++x) {
			for(int y=0; y<4; ++y) {

				// skip random
				if(Random.Range(0f, 1f) > 0.7f ) {
					continue;
				}

				GameObject t = (GameObject)Instantiate(cube, Vector3.zero, Quaternion.identity);
				t.transform.parent = transform;
				//t.transform.localPosition = new Vector3( Random.Range(-1f, 1f), Random.Range(-1f, 1f), 10f );
				t.transform.localPosition = new Vector3( (x-4)*0.05f, (y-1)*0.05f, 10f );

				float s = 0.22f;//Random.Range(0.9f, 1.1f);
				t.transform.localScale = new Vector3(s*multiplier,s*multiplier,s*multiplier);

				// cubes
				GameObject c = (GameObject)Instantiate(cubeObject, Vector3.zero, Quaternion.identity);
				c.transform.parent = container;
				c.transform.localPosition = new Vector3( -t.transform.localPosition.x, 0, -t.transform.localPosition.y )*5f;
				c.transform.localScale = new Vector3(s*1.12f,s*3f,s*1.12f);

			}
		}


		for(int i=0; i<20; ++i) {

			float x = Random.Range(-0.6f, 0.6f);
			float y = Random.Range(-0.8f, 0.5f);

			if(x < 0.25f && x > -0.25f) {
				if(y < 0.12f && y > -0.12f) {
					continue;
				}
			}

			GameObject t = (GameObject)Instantiate(sphere, Vector3.zero, Quaternion.identity);
			t.transform.parent = transform;
			t.transform.localPosition = new Vector3( x, y, 10f );
			float s = Random.Range(0.05f, 0.2f);
			t.transform.localScale = new Vector3(s*1.5f,s*1.5f,s*1.5f);

			// cylinders
			GameObject c = (GameObject)Instantiate(cylinderObject, Vector3.zero, Quaternion.identity);
			c.transform.parent = container;
			c.transform.localPosition = new Vector3( -t.transform.localPosition.x, 0, -t.transform.localPosition.y )*5f;
			c.transform.localScale = new Vector3(s*0.6f,s*4f,s*0.6f);
			c.transform.localRotation = Quaternion.Euler(Random.Range(-20f, 20f),0f,Random.Range(-20f, 20f));
		}



	}

	// Update is called once per frame
	void Update () {

	}
}
