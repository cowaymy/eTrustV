package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGISTOService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGISTOServiceImpl.java
 * @Description : GI STO Serial NO Scanning
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.21.     KR-JUN       First creation
 * </pre>
 */
@Service("SerialScanningGISTOService")
public class SerialScanningGISTOServiceImpl implements SerialScanningGISTOService {
	private static final Logger logger = LoggerFactory.getLogger(SerialScanningGISTOServiceImpl.class);

	@Resource(name = "SerialScanningGISTOMapper")
	private SerialScanningGISTOMapper serialScanningGISTOMapper;

	@Override
	public List<EgovMap> serialScanningGISTODataList(Map<String, Object> params) {
		return serialScanningGISTOMapper.serialScanningGISTODataList(params);
	}
}