/**
 * 
 */
package com.coway.trust.biz.sales.pst;

import java.io.Serializable;

/**
 * @author Yunseok_Jang
 *
 */
public class PSTRequestDOVO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5608032363988701275L;
	
	/** 아이디 */
	private String id;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

}
