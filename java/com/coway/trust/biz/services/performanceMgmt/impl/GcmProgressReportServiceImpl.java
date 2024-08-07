package com.coway.trust.biz.services.performanceMgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.services.performanceMgmt.GcmProgressReportService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : GcmProgressReportServiceImpl.java
 * @Description : GCM Progress Report Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 29.   KR-OHK        First creation
 * </pre>
 */

@Service("gcmProgressReportService")
public class GcmProgressReportServiceImpl  implements GcmProgressReportService{

	@Resource(name = "gcmProgressReportMapper")
	private GcmProgressReportMapper gcmProgressReportMapper;

	@Override
	public List<EgovMap> selectMemList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectMemList(params);
	}

	@Override
	public List<EgovMap> selectScmList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectScmList(params);
	}

	@Override
	public List<EgovMap> selectCmList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectCmList(params);
	}

	@Override
	public List<EgovMap> selectCodyList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectCodyList(params);
	}

	@Override
	public List<EgovMap> selectCodyRowDataList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectCodyRowDataList(params);
	}

	@Override
	public List<EgovMap> selectHearServiceList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectHearServiceList(params);
	}

	@Override
	public List<EgovMap> selectRentalCollectionList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectRentalCollectionList(params);
	}

	@Override
	public List<EgovMap> selectSalesNetList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectSalesNetList(params);
	}

	@Override
	public List<EgovMap> selectSalesProdList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectSalesProdList(params);
	}

	@Override
	public List<EgovMap> selectRejoinList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectRejoinList(params);
	}

	@Override
	public List<EgovMap> selectMBOSalesList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectMBOSalesList(params);
	}

	@Override
	public List<EgovMap> selectMBOSVMList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectMBOSVMList(params);
	}

	@Override
	public List<EgovMap> selectRetentionList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectRetentionList(params);
	}

	@Override
	public List<EgovMap> selectCFFList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectCFFList(params);
	}

	@Override
	public List<EgovMap> selectGcmPEList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectGcmPEList(params);
	}

	@Override
	public List<EgovMap> selectScmPEAList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectScmPEAList(params);
	}

	@Override
	public List<EgovMap> selectCmPEAList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectCmPEAList(params);
	}

	@Override
	public List<EgovMap> selectCodyPEAList(Map<String, Object> params) {
		return gcmProgressReportMapper.selectCodyPEAList(params);
	}
}
