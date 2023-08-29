package com.coway.trust.config.ctos.client.xml.proxy.ws;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@Builder
@AllArgsConstructor
public class ResRequestVO {

	private String custIc;
	private String batchNo;
	private int ficoScore;
	private String resultRaw;
	private Date ctosDate;
	private String bankRupt;
	private String confirmEntity;

}
