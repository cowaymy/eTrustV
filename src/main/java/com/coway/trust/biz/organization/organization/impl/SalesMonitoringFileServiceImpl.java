package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.SalesMonitoringFileService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SalesMonitoringFileService")
public class SalesMonitoringFileServiceImpl implements SalesMonitoringFileService {

    @Resource(name = "SalesMonitoringFileMapper")
    private SalesMonitoringFileMapper salesMonitoringFileMapper;

	@Override
    public List<EgovMap> selectSummarySalesListing(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectSummarySalesListing(params);
    }

	@Override
    public List<EgovMap> selectWeekSalesListing(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectWeekSalesListing(params);
    }

	@Override
    public List<EgovMap> selectPerformanceView(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectPerformanceView(params);
    }

	@Override
    public List<EgovMap> selectSmfHA(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectSmfHA(params);
    }

	@Override
    public List<EgovMap> selectSmfHC(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectSmfHC(params);
    }


	@Override
    public List<EgovMap> selectSmfActHp(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectSmfActHp(params);
    }

	@Override
    public List<EgovMap> selectSmfDailyListing(Map<String, Object> params) {
        return salesMonitoringFileMapper.selectSmfDailyListing(params);
    }




}
