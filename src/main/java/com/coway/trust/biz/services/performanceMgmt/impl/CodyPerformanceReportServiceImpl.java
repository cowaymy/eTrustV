package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.CodyPerformanceReportService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : CodyPerformanceReportServiceImpl.java
 * @Description : Cody Performance Report Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 06.   KR-OHK        First creation
 * </pre>
 */

@Service("codyPerformanceReportService")
public class CodyPerformanceReportServiceImpl  implements CodyPerformanceReportService{

	@Resource(name = "codyPerformanceReportMapper")
	private CodyPerformanceReportMapper codyPerformanceReportMapper;

	@Override
	public List<EgovMap> selectCodyHCList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyHCList(params);
	}

	@Override
	public List<EgovMap> selectCodyHSOverallList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyHSOverallList(params);
	}

	@Override
	public List<EgovMap> selectCodyHSList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyHSList(params);
	}

	@Override
	public List<EgovMap> selectCodyHSCorporateRatioList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyHSCorporateRatioList(params);
	}

	@Override
	public List<EgovMap> selectCodyRCOverallList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyRCOverallList(params);
	}

	@Override
	public List<EgovMap> selectCodyRCList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyRCList(params);
	}

	@Override
	public List<EgovMap> selectCodySalesOverallList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodySalesOverallList(params);
	}

	@Override
	public List<EgovMap> selectCodySalesList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodySalesList(params);
	}

	@Override
	public List<EgovMap> selectCodySVMOverallList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodySVMOverallList(params);
	}

	@Override
	public List<EgovMap> selectCodySVMList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodySVMList(params);
	}

	@Override
	public List<EgovMap> selectCodyRTOverallList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyRTOverallList(params);
	}

	@Override
	public List<EgovMap> selectCodyRTList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyRTList(params);
	}

	@Override
	public List<EgovMap> selectCodyCFFOverallList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyCFFOverallList(params);
	}

	@Override
	public List<EgovMap> selectCodyPEList(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectCodyPEList(params);
	}

	@Override
	public EgovMap selectMemberInfo(Map<String, Object> params) {
		return codyPerformanceReportMapper.selectMemberInfo(params);
	}
}
