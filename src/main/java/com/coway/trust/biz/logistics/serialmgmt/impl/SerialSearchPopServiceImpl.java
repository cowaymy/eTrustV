package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialmgmt.SerialSearchPopService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialSearchPopServiceImpl.java
 * @Description : Serial Search
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.28.     KR-JUN       First creation
 * </pre>
 */
@Service("SerialSearchPopService")
public class SerialSearchPopServiceImpl implements SerialSearchPopService {
	private static final Logger logger = LoggerFactory.getLogger(SerialSearchPopServiceImpl.class);

	@Resource(name = "SerialSearchPopMapper")
	private SerialSearchPopMapper serialSearchPopMapper;

	@Override
	public List<EgovMap> serialSearchDataList(Map<String, Object> params) {
		return serialSearchPopMapper.serialSearchDataList(params);
	}
}