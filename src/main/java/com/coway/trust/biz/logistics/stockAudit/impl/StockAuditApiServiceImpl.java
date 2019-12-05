package com.coway.trust.biz.logistics.stockAudit.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiDto;
import com.coway.trust.api.mobile.logistics.stockAudit.StockAuditApiFormDto;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.logistics.stockAudit.StockAuditApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : StockAuditApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 28.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("StockAuditApiService")
public class StockAuditApiServiceImpl extends EgovAbstractServiceImpl implements StockAuditApiService{



	@Resource(name = "StockAuditApiMapper")
	private StockAuditApiMapper stockAuditApiMapper;



    @Autowired
    private LoginMapper loginMapper;



    @Override
    public List<EgovMap> selectStockAuditList(StockAuditApiFormDto param) {
        if( CommonUtils.isEmpty(param.getRegId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
        }

        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "Reg ID value does not exist.");
        }
        param.setWhLocId(loginVO.getUserId());
        return stockAuditApiMapper.selectStockAuditList(StockAuditApiFormDto.createMap(param));
    }



    @Override
    public EgovMap selectStockAuditDetail(StockAuditApiFormDto param) {
        if( CommonUtils.isEmpty( param.getStockAuditNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Stock Audit Number value does not exist.");
        }
        if( CommonUtils.isEmpty(String.valueOf(param.getWhLocId())) || param.getWhLocId() <= 0 ){
            throw new ApplicationException(AppConstants.FAIL, "WHLocID value does not exist.");
        }
        return stockAuditApiMapper.selectStockAuditDetail(StockAuditApiFormDto.createMap(param));
    }



    @Override
    public Map<String, Object> selectStockAuditDetailList(StockAuditApiFormDto param) {
        if( CommonUtils.isEmpty( param.getStockAuditNo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Stock Audit Number value does not exist.");
        }
        if( CommonUtils.isEmpty(String.valueOf(param.getWhLocId())) || param.getWhLocId() <= 0 ){
            throw new ApplicationException(AppConstants.FAIL, "WHLocID value does not exist.");
        }

        EgovMap detail = stockAuditApiMapper.selectStockAuditDetail(StockAuditApiFormDto.createMap(param));
        List<EgovMap> detailList = stockAuditApiMapper.selectStockAuditDetailList(StockAuditApiFormDto.createMap(param));

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("detail", StockAuditApiDto.create(detail));
        resultMap.put("detailList", detailList.stream().map(r -> StockAuditApiDto.create(r)).collect(Collectors.toList()));
        return resultMap;
    }



    @Override
    public List<StockAuditApiDto> saveStockAudit(List<StockAuditApiDto> param) throws Exception {
        if( param.size() == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
        for( StockAuditApiDto saveData : param){
            if( CommonUtils.isEmpty(saveData.getStockAuditNo()) ){
                throw new ApplicationException(AppConstants.FAIL, "Stock Audit Number value does not exist.");
            }
            if( CommonUtils.isEmpty(String.valueOf(saveData.getWhLocId())) || saveData.getWhLocId() <= 0 ){
                throw new ApplicationException(AppConstants.FAIL, "WHLocID value does not exist.");
            }
            if( CommonUtils.isEmpty(String.valueOf(saveData.getItmId())) || saveData.getItmId() <= 0 ){
                throw new ApplicationException(AppConstants.FAIL, "Item ID value does not exist.");
            }
            if( CommonUtils.isEmpty(String.valueOf(saveData.getCntQty())) ){
                throw new ApplicationException(AppConstants.FAIL, "Please check your Remark.");
            }
            if( CommonUtils.isEmpty(saveData.getRem()) == false && saveData.getRem().getBytes().length > 400){
                throw new ApplicationException(AppConstants.FAIL, "Please check your Remark.");
            }

            Map<String, Object> loginInfoMap = new HashMap<String, Object>();
            loginInfoMap.put("_USER_ID", saveData.getRegId());
            LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
            if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
                throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
            }

            Map<String, Object> log0095m = new HashMap<String, Object>();
            log0095m.put("stockAuditNo", saveData.getStockAuditNo());
            log0095m.put("whLocId", saveData.getWhLocId());
            log0095m.put("updUserId", loginVO.getUserId());
            int saveCnt = stockAuditApiMapper.updateSaveLocStusCodeIdLOG0095M(log0095m);
            if( saveCnt == 0 ){
                throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
            }

            Map<String, Object> log0096m = new HashMap<String, Object>();
            log0096m.put("stockAuditNo", saveData.getStockAuditNo());
            log0096m.put("whLocId", saveData.getWhLocId());
            log0096m.put("itmId", saveData.getItmId());
            log0096m.put("cntQty", saveData.getCntQty());
            log0096m.put("diffQty", saveData.getDiffQty());
            log0096m.put("otherQty", saveData.getDiffQty());
            log0096m.put("rem", saveData.getRem());
            log0096m.put("updUserId", loginVO.getUserId());
            saveCnt = stockAuditApiMapper.updateSaveLocStusCodeIdLOG0096D(log0096m);
            if( saveCnt == 0 ){
                throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
            }
        }
        return param;
    }



    @Override
    public List<StockAuditApiDto> saveRequestApprovalStockAudit(List<StockAuditApiDto> param) throws Exception {
        if( param.size() == 0 ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.get(0).getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
        }

        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        for( StockAuditApiDto saveData : param){
            if( CommonUtils.isEmpty(saveData.getStockAuditNo()) ){
                throw new ApplicationException(AppConstants.FAIL, "Stock Audit Number value does not exist.");
            }
            if( CommonUtils.isEmpty(String.valueOf(saveData.getWhLocId())) || saveData.getWhLocId() <= 0 ){
                throw new ApplicationException(AppConstants.FAIL, "WHLocID value does not exist.");
            }
            if( CommonUtils.isEmpty(String.valueOf(saveData.getItmId())) || saveData.getItmId() <= 0 ){
                throw new ApplicationException(AppConstants.FAIL, "Item ID value does not exist.");
            }
            Map<String, Object> log0095m = new HashMap<String, Object>();
            log0095m.put("stockAuditNo", saveData.getStockAuditNo());
            log0095m.put("whLocId", saveData.getWhLocId());
            log0095m.put("updUserId", loginVO.getUserId());
            list.add(log0095m);
        }

        HashSet<Map<String, Object>> distinctMap = new HashSet<>(list);
        list = new ArrayList<Map<String,Object>>(distinctMap);
        for(Map<String,Object> saveData : list){
            Map<String, Object> log0095m = new HashMap<String, Object>();
            log0095m.put("stockAuditNo", saveData.get("stockAuditNo"));
            log0095m.put("whLocId", saveData.get("whLocId"));
            log0095m.put("updUserId", saveData.get("updUserId"));
            int saveCnt = stockAuditApiMapper.updateRequestApproval(log0095m);
            if( saveCnt == 0 ){
                throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
            }
        }
        return param;
    }
}
