package com.coway.trust.api.sap.host2host;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InterfaceCIMBForm", description = "InterfaceCIMBForm")
public class InterfaceCIMBForm {

	//@ApiModelProperty(value = "server")
	//private String server;

	@ApiModelProperty(value = "fileName")
	private String fileName;

	/*public String getServer() {
		return server;
	}

	public void setServer(String server) {
		this.server = server;
	}*/

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}


	/**
	 * serivce 의 파라미터가 map 인 경우.
	 *
	 * @param sampleForm
	 * @return
	 * @throws Exception
	 */
	public Map createMap(InterfaceCIMBForm interfaceCIMBForm) {
		return BeanConverter.toMap(interfaceCIMBForm);
	}


}
