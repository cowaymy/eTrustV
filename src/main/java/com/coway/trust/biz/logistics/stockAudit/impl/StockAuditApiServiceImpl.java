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
import com.coway.trust.biz.logistics.barcodeRegister.impl.BarcodeRegisterApiMapper;
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



    @Resource(name = "barcodeRegisterApiMapper")
    private BarcodeRegisterApiMapper barcodeRegisterApiMapper;



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

        Map<String, Object> loginInfoMap = new HashMap<String, Object>();
        loginInfoMap.put("_USER_ID", param.get(0).getRegId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(loginInfoMap);
        if( null == loginVO || CommonUtils.isEmpty(loginVO.getUserId()) ){
            throw new ApplicationException(AppConstants.FAIL, "User ID value does not exist.");
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
            if( saveData.getSerialChkYn().equals("Y") && saveData.getSerialChk().equals("Y") && saveData.getSerialRequireChkYn().equals("Y") ){
                if( CommonUtils.isNotEmpty(saveData.getDelSerialArr()) ){
                    String[] delSerialArr = saveData.getDelSerialArr().split(",");
                    for( int i = 0 ; i < delSerialArr.length ; i++){
                        Map<String, Object> spLogisticBarcodeDelete = new HashMap<String, Object>();
                        spLogisticBarcodeDelete.put("pSerialNo", delSerialArr[i]);
                        spLogisticBarcodeDelete.put("pReqstNo", saveData.getStockAuditNo());
                        spLogisticBarcodeDelete.put("pDelvryNo", null);
                        spLogisticBarcodeDelete.put("pTrnscType", "AD");
                        spLogisticBarcodeDelete.put("pIoType", "I");
                        spLogisticBarcodeDelete.put("pUserId", loginVO.getUserId());
                        barcodeRegisterApiMapper.deleteBarcode(spLogisticBarcodeDelete);
                        String errcodeScan = (String)spLogisticBarcodeDelete.get("errcode");
                        String errmsgScan = (String)spLogisticBarcodeDelete.get("errmsg");
                        if(!errcodeScan.equals("000")){
                            throw new ApplicationException(AppConstants.FAIL, errmsgScan);
                        }
                    }
                }
            }
        }

        String log0094mStockAuditNo = "";
        String log0095mStockAuditNo = "";
        int whLocId = 0;
        int saveCnt = 0;
        for( StockAuditApiDto saveData : param ){
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

            if( (CommonUtils.isEmpty(log0094mStockAuditNo) || log0094mStockAuditNo.equals(saveData.getStockAuditNo()) == false) && ( saveData.getLocStusCodeId() == 5713) ){//5713(3rd Reject)
                Map<String, Object> log0094m = new HashMap<String, Object>();
                log0094m.put("stockAuditNo", saveData.getStockAuditNo());
                log0094m.put("updUserId", loginVO.getUserId());
                saveCnt = stockAuditApiMapper.updateAppv3LOG0094M(log0094m);
                if( saveCnt != 1 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }
                log0094mStockAuditNo = saveData.getStockAuditNo();
            }

            if( (CommonUtils.isEmpty(log0095mStockAuditNo) && whLocId == 0) || (log0095mStockAuditNo.equals(saveData.getStockAuditNo()) == false && whLocId != saveData.getWhLocId()) ){
                Map<String, Object> log0095m = new HashMap<String, Object>();
                log0095m.put("stockAuditNo", saveData.getStockAuditNo());
                log0095m.put("whLocId", saveData.getWhLocId());
                log0095m.put("updUserId", loginVO.getUserId());

                saveCnt = stockAuditApiMapper.insertStockAuditLocHistoryLOG0095M(log0095m);
                if( saveCnt != 1 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }

                saveCnt = stockAuditApiMapper.updateSaveLocStusCodeIdLOG0095M(log0095m);
                if( saveCnt != 1 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }
                log0095mStockAuditNo = saveData.getStockAuditNo();
                whLocId = saveData.getWhLocId();
            }

            if( saveData.getSerialChkYn().equals("Y") && saveData.getSerialChk().equals("Y") && saveData.getSerialRequireChkYn().equals("Y") ){
                Map<String, Object> log0096d = new HashMap<String, Object>();
                log0096d.put("stockAuditNo", saveData.getStockAuditNo());
                log0096d.put("whLocId", saveData.getWhLocId());
                log0096d.put("itmId", saveData.getItmId());
//                log0096d.put("cntQty", saveData.getCntQty());
//                log0096d.put("diffQty", saveData.getDiffQty());
//                log0096d.put("otherQty", saveData.getDiffQty());
                log0096d.put("rem", saveData.getRem());
                log0096d.put("updUserId", loginVO.getUserId());

                saveCnt = stockAuditApiMapper.insertStockAuditItemHistoryLOG0096D(log0096d);
                if( saveCnt == 0 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }

                saveCnt = stockAuditApiMapper.updateSaveLocStusCodeIdBarcodeLOG0096D(log0096d);
                if( saveCnt == 0 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }

                if( CommonUtils.isNotEmpty(saveData.getNewSerialArr()) ){
                    String[] newSerialArr = saveData.getNewSerialArr().split(",");
                    for( int i = 0 ; i < newSerialArr.length ; i++){
                        Map<String, Object> spLogisticBarcodeScanAdjst = new HashMap<String, Object>();
                        spLogisticBarcodeScanAdjst.put("pScanNo", null);
                        spLogisticBarcodeScanAdjst.put("pSerialNo", newSerialArr[i]);
                        spLogisticBarcodeScanAdjst.put("pReqstNo", saveData.getStockAuditNo());
                        spLogisticBarcodeScanAdjst.put("pFromLocId", saveData.getWhLocId());
                        spLogisticBarcodeScanAdjst.put("pTrnscType", "AD");//SAVE
                        spLogisticBarcodeScanAdjst.put("pUserId", loginVO.getUserId());

                        barcodeRegisterApiMapper.adMobileCheckBarcode(spLogisticBarcodeScanAdjst);
                        String errcodeScan = (String)spLogisticBarcodeScanAdjst.get("errcode");
                        String errmsgScan = (String)spLogisticBarcodeScanAdjst.get("errmsg");
                        if(!errcodeScan.equals("000")){
                            throw new ApplicationException(AppConstants.FAIL, errmsgScan);
                        }
                    }
                }
            }else{
                Map<String, Object> log0096d = new HashMap<String, Object>();
                log0096d.put("stockAuditNo", saveData.getStockAuditNo());
                log0096d.put("whLocId", saveData.getWhLocId());
                log0096d.put("itmId", saveData.getItmId());
                log0096d.put("cntQty", saveData.getCntQty());
                log0096d.put("diffQty", saveData.getDiffQty());
                log0096d.put("otherQty", saveData.getDiffQty());
                log0096d.put("rem", saveData.getRem());
                log0096d.put("updUserId", loginVO.getUserId());

                saveCnt = stockAuditApiMapper.insertStockAuditItemHistoryLOG0096D(log0096d);
                if( saveCnt == 0 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }

                saveCnt = stockAuditApiMapper.updateSaveLocStusCodeIdLOG0096D(log0096d);
                if( saveCnt == 0 ){
                    throw new ApplicationException(AppConstants.FAIL, "Failed to update.");
                }
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

        HashSet<Map<String, Object>> distinctMap = new HashSet<>(list);         //중복제거
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
