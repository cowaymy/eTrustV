package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialmgmt.ScanSearchPopService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ScanSearchPopServiceImpl.java
 * @Description : Scan Search
 *
 * @History
 *
 * <pre>
 * Date               Author       Description
 * -------------  -----------  -------------
 * 2019.11.26.     KR-JUN       First creation
 * </pre>
 */
@Service("ScanSearchPopService")
public class ScanSearchPopServiceImpl implements ScanSearchPopService {
	private static final Logger logger = LoggerFactory.getLogger(ScanSearchPopServiceImpl.class);

	@Resource(name = "ScanSearchPopMapper")
	private ScanSearchPopMapper scanSearchPopMapper;

	@Override
	public List<EgovMap> scanSearchDataList(Map<String, Object> params) {
		return scanSearchPopMapper.scanSearchDataList(params);
	}
}