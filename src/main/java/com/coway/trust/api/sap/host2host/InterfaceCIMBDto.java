package com.coway.trust.api.sap.host2host;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description = "InterfaceCIMBResult")
public class InterfaceCIMBDto
{
	//@ApiModelProperty(value = "server")
	//private String server;

	@ApiModelProperty(value = "fileName")
	private String fileName;

	@ApiModelProperty(value = "code")
	private String code;

	@ApiModelProperty(value = "message")
	private String message;

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

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

    public static InterfaceCIMBDto create( EgovMap egvoMap )
    {
    	return BeanConverter.toBean(egvoMap, InterfaceCIMBDto.class);

    }
}
