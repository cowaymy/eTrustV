package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGRService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGRServiceImpl.java
 * @Description : GR Serial NO Scanning
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.21.     KR-JUN       First creation
 * </pre>
 */
@Service("SerialScanningGRService")
public class SerialScanningGRServiceImpl implements SerialScanningGRService {
	private static final Logger logger = LoggerFactory.getLogger(SerialScanningGRServiceImpl.class);

	@Resource(name = "SerialScanningGRMapper")
	private SerialScanningGRMapper serialScanningGRMapper;

	@Override
	public List<EgovMap> serialScanningGRCommonCode(Map<String, Object> params) {
		return serialScanningGRMapper.serialScanningGRCommonCode(params);
	}

	@Override
	public String selectDefLocationType(Map<String, Object> params) {
		return serialScanningGRMapper.selectDefLocationType(params);
	}

	@Override
	public String selectDefLocationCode(Map<String, Object> params) {
		return serialScanningGRMapper.selectDefLocationCode(params);
	}

	@Override
	public List<EgovMap> serialScanningGRDataList(Map<String, Object> params) {
		return serialScanningGRMapper.serialScanningGRDataList(params);
	}
}