package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.ClProgressReportService;
import com.coway.trust.biz.services.performanceMgmt.GcmProgressReportService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : ClProgressReportServiceImpl.java
 * @Description : CL Progress Report Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 31.   KR-OHK        First creation
 * </pre>
 */

@Service("clProgressReportService")
public class ClProgressReportServiceImpl  implements ClProgressReportService{

	@Resource(name = "clProgressReportMapper")
	private ClProgressReportMapper clProgressReportMapper;

	@Override
	public List<EgovMap> selectGcmList(Map<String, Object> params) {
		return clProgressReportMapper.selectGcmList(params);
	}

	@Override
	public List<EgovMap> selectScmList(Map<String, Object> params) {
		return clProgressReportMapper.selectScmList(params);
	}

	@Override
	public List<EgovMap> selectCmList(Map<String, Object> params) {
		return clProgressReportMapper.selectCmList(params);
	}

	@Override
	public List<EgovMap> selectCodyList(Map<String, Object> params) {
		return clProgressReportMapper.selectCodyList(params);
	}

	@Override
	public List<EgovMap> selectHearServiceList(Map<String, Object> params) {
		return clProgressReportMapper.selectHearServiceList(params);
	}

	@Override
	public List<EgovMap> selectRentalCollectionList(Map<String, Object> params) {
		return clProgressReportMapper.selectRentalCollectionList(params);
	}

	@Override
	public List<EgovMap> selectSalesNetAppList(Map<String, Object> params) {
		return clProgressReportMapper.selectSalesNetAppList(params);
	}

	@Override
	public List<EgovMap> selectSalesNetCatList(Map<String, Object> params) {
		return clProgressReportMapper.selectSalesNetCatList(params);
	}

	@Override
	public List<EgovMap> selectRejoinList(Map<String, Object> params) {
		return clProgressReportMapper.selectRejoinList(params);
	}

	@Override
	public List<EgovMap> selectMBOSalesList(Map<String, Object> params) {
		return clProgressReportMapper.selectMBOSalesList(params);
	}

	@Override
	public List<EgovMap> selectMBOSVMList(Map<String, Object> params) {
		return clProgressReportMapper.selectMBOSVMList(params);
	}

	@Override
	public List<EgovMap> selectRetentionList(Map<String, Object> params) {
		return clProgressReportMapper.selectRetentionList(params);
	}

	@Override
	public List<EgovMap> selectCFFList(Map<String, Object> params) {
		return clProgressReportMapper.selectCFFList(params);
	}

	@Override
	public List<EgovMap> selectPEAList(Map<String, Object> params) {
		return clProgressReportMapper.selectPEAList(params);
	}

}
