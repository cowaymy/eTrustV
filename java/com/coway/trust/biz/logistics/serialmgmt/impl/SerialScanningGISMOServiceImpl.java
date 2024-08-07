package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialmgmt.SerialScanningGISMOService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialScanningGISMOServiceImpl.java
 * @Description : GI Serial No. Scanning (SMO) Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 21.   KR-OHK        First creation
 * </pre>
 */
@Service("serialScanningGISMOService")
public class SerialScanningGISMOServiceImpl implements SerialScanningGISMOService
{

	private static final Logger logger = LoggerFactory.getLogger(SerialScanningGISMOServiceImpl.class);

	@Resource(name = "serialScanningGISMOMapper")
	private SerialScanningGISMOMapper serialScanningGISMOMapper;

	@Override
	public List<EgovMap> selectSerialScanningGISMOList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialScanningGISMOMapper.selectSerialScanningGISMOList(params);
	}
}