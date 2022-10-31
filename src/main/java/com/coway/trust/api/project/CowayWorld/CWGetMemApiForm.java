package com.coway.trust.api.project.CowayWorld;

import java.util.HashMap;
import java.util.Map;

import org.jsoup.helper.StringUtil;

import antlr.StringUtils;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CWGetMemApiForm.java
 * @Description : TO-DO Class Description
 *
 * @HistoryselectAnotherContact
 *
 *                              <pre>
 * Date                Author         Description
 * -------------       -----------      -------------
 * 2021. 10. 27.    MY-HLTANG   First creation- API for coway world
 *                              </pre>
 */
@ApiModel(value = "CWGetMemApiForm", description = "CWGetMemApiForm")
public class CWGetMemApiForm {

	private String username;

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}


}
