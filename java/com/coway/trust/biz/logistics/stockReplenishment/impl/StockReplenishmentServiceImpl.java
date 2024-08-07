package com.coway.trust.biz.logistics.stockReplenishment.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.stockReplenishment.StockReplenishmentService;
import com.coway.trust.biz.sample.impl.SampleServiceImpl;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("StockReplenishmentService")
public class StockReplenishmentServiceImpl implements StockReplenishmentService {

	private static final Logger LOGGER = LoggerFactory.getLogger(StockReplenishmentServiceImpl.class);

    @Resource(name = "StockReplenishmentMapper")
    private StockReplenishmentMapper stockReplenishmentMapper;


    @Override
	public List<EgovMap> selectWeekList(Map<String, Object> params) {
	    return stockReplenishmentMapper.selectWeekList(params);
	}

    @Override
	public List<EgovMap> selectSroCodyList(Map<String, Object> params) {
	    return stockReplenishmentMapper.selectSroCodyList(params);
	}

    @Override
   	public List<EgovMap> selectSroRdcList(Map<String, Object> params) {
   	    return stockReplenishmentMapper.selectSroRdcList(params);
   	}

    @Override
   	public List<EgovMap> selectSroList(Map<String, Object> params) {
   	    return stockReplenishmentMapper.selectSroList(params);
   	}

    @Override
	public List<EgovMap> selectSroSafetyLvlList(Map<String, Object> params) {
	    return stockReplenishmentMapper.selectSroSafetyLvlList(params);
	}

    @Override
	public int updateMergeLOG0119M(Map<String, Object> params) {

		// TODO Auto-generated method stub
		List<Map<String, Object>> udtList = (List<Map<String, Object>>) params.get(AppConstants.AUIGRID_UPDATE);
		List<Map<String, Object>> addList = (List<Map<String, Object>>) params.get(AppConstants.AUIGRID_ADD);

		int updResult = 0;

        if (addList !=null ){
    		if (addList.size() > 0) {
    			for (Object obj : addList) {
    				((Map<String, Object>) obj).put("userId", params.get("userId"));

    				updResult = stockReplenishmentMapper.updateMergeLOG0119M((Map<String, Object>) obj);
    			}
    		}
        }

        if (udtList !=null ){
    		if (udtList.size() > 0) {
    			for (Object obj : udtList) {
    				((Map<String, Object>) obj).put("userId", params.get("userId"));

    				updResult= stockReplenishmentMapper.updateMergeLOG0119M((Map<String, Object>) obj);
    			}
    		}
        }

        return updResult;
	}


    @Override
	public List<EgovMap> selectSroLocationType(Map<String, Object> params) {
		return stockReplenishmentMapper.selectSroLocationType(params);
	}


    @Override
	public List<EgovMap> selectSroStatus(Map<String, Object> params) {
		return stockReplenishmentMapper.selectSroStatus(params);
	}

    @Override
	public List<EgovMap> selectWeeklyList(Map<java.lang.String, Object> params) {
		return stockReplenishmentMapper.selectWeeklyList(params);
	}

    @Override
	@Transactional
	public int saveSroCalendarGrid(List<Object> dataList, String userId)  {
    	int cnt=0;
    	for (Object obj : dataList) {
    		((Map<String, Object>) obj).put("userId", userId);
    		cnt = stockReplenishmentMapper.saveSroCalendarGrid((Map<String, Object>) obj);
    	}
	    return cnt;
	}

    @Override
    public List<EgovMap> selectYearList(Map<String, Object> params) {
    	return stockReplenishmentMapper.selectYearList(params);
    }

    @Override
    public List<EgovMap> selectMonthList(Map<String, Object> params) {
    	return stockReplenishmentMapper.selectMonthList(params);
    }



}
