package com.coway.trust.biz.logistics.barcodeRegister.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.barcodeRegister.BarcodeRegisterApiForm;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.logistics.barcodeRegister.BarcodeRegisterApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : BarcodeRegisterApiServiceImple.java
 * @Description : 바코드 등록 API ServiceImple
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 17.   KR-HAN        First creation
 * </pre>
 */
@Service("barcodeRegisterApiService")
public class BarcodeRegisterApiServiceImple extends EgovAbstractServiceImpl implements BarcodeRegisterApiService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "barcodeRegisterApiMapper")
	private BarcodeRegisterApiMapper barcodeRegisterApiMapper;

	@Autowired
	private LoginMapper loginMapper;

	/**
	 * 바코드 등록 리스트
	 * @Author KR-HAN
	 * @Date 2019. 12. 17.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.logistics.barcodeRegister.BarcodeRegisterApiService#selectBarcodeRegisterList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectBarcodeRegisterList(Map<String, Object> params) {
		return barcodeRegisterApiMapper.selectBarcodeRegisterList(params);
	}

	/**
	 * saveBarcode
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 * @see com.coway.trust.biz.logistics.barcodeRegister.BarcodeRegisterApiService#saveBarcode(com.coway.trust.api.mobile.logistics.barcodeRegister.BarcodeRegisterApiForm)
	 */
	@Override
	public void saveBarcode(BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {

		Map<String, Object> params = BarcodeRegisterApiForm.createMap(barcodeRegisterApiForm);

		params.put("_USER_ID", barcodeRegisterApiForm.getUserId());
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		System.out.println("++++ saveBarcode params.toString() ::" + params.toString() );
		String scanNo = "";
		if (params.get("serialNo") != null && params.get("serialNo") != "") {
			// scan info

			Map<String, Object> outScanMap = new HashMap<String, Object>();
			outScanMap.put("pScanNo", params.get("scanNo"));
			outScanMap.put("pSerialNo", params.get("serialNo"));
			outScanMap.put("pReqstNo", params.get("reqstNo"));
			outScanMap.put("pDelvryNo", params.get("delvryNo"));

			outScanMap.put("pFromLocId", params.get("fromLocId"));
			outScanMap.put("pToLocId", params.get("toLocId"));
			outScanMap.put("pTrnscType", params.get("trnscType"));

			outScanMap.put("pIoType", params.get("ioType"));
			outScanMap.put("pUserId", params.get("userId"));

			// SP_LOGISTIC_BARCODE_SCAN call
			barcodeRegisterApiMapper.saveBarcodeScan(outScanMap);

			logger.debug("++++ saveBarcode outScanMap ::" + outScanMap );

			String errcodeScan = (String)outScanMap.get("errcode");
			String errmsgScan = (String)outScanMap.get("errmsg");
			if(!errcodeScan.equals("000")){
				throw new ApplicationException(AppConstants.FAIL, errmsgScan);
			}

			scanNo = (String)outScanMap.get("outScanNo");
		}

	}

	/**
	 * deleteBarcode
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 * @see com.coway.trust.biz.logistics.barcodeRegister.BarcodeRegisterApiService#deleteBarcode(com.coway.trust.api.mobile.logistics.barcodeRegister.BarcodeRegisterApiForm)
	 */
	@Override
	public void deleteBarcode(BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {

		Map<String, Object> params = BarcodeRegisterApiForm.createMap(barcodeRegisterApiForm);

		params.put("_USER_ID", barcodeRegisterApiForm.getUserId());
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		logger.debug("++++ saveBarcode params.toString() ::" + params.toString() );

		String scanNo = "";
		if (params.get("serialNo") != null && params.get("serialNo") != "") {
			// scan info

			Map<String, Object> outScanMap = new HashMap<String, Object>();
			outScanMap.put("pSerialNo", params.get("serialNo"));
			outScanMap.put("pReqstNo", params.get("reqstNo"));
			outScanMap.put("pDelvryNo", params.get("delvryNo"));
			outScanMap.put("pTrnscType", params.get("trnscType"));
			outScanMap.put("pIoType", params.get("ioType"));
			outScanMap.put("pUserId", params.get("userId"));

			// SP_LOGISTIC_BARCODE_SCAN call
			barcodeRegisterApiMapper.deleteBarcode(outScanMap);

			logger.debug("++++ deleteBarcode outScanMap ::" + outScanMap );

			String errcodeScan = (String)outScanMap.get("errcode");
			String errmsgScan = (String)outScanMap.get("errmsg");
			if(!errcodeScan.equals("000")){
				throw new ApplicationException(AppConstants.FAIL, errmsgScan);
			}

			scanNo = (String)outScanMap.get("outScanNo");
		}

	}

    /**
     * AD_MOBILE_CHECK(Audit Mobile Check)
     * @Author KR-KangJaeMin
     * @Date 2019. 12. 31.
     * @param barcodeRegisterApiForm
     * @throws Exception
     * @see com.coway.trust.biz.logistics.barcodeRegister.BarcodeRegisterApiService#adMobileCheckBarcode(com.coway.trust.api.mobile.logistics.barcodeRegister.BarcodeRegisterApiForm)
     */
    @Override
    public List<BarcodeRegisterApiForm> adMobileCheckBarcode(BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception {
        Map<String, Object> params = BarcodeRegisterApiForm.createMap(barcodeRegisterApiForm);
        params.put("_USER_ID", barcodeRegisterApiForm.getUserId());
        LoginVO loginVO = loginMapper.selectLoginInfoById(params);
        params.put("userId",  loginVO.getUserId());

        if (params.get("serialNo") != null && params.get("serialNo") != "") {
            Map<String, Object> outScanMap = new HashMap<String, Object>();
            outScanMap.put("pScanNo", params.get("scanNo"));
            outScanMap.put("pSerialNo", params.get("serialNo"));
            outScanMap.put("pReqstNo", params.get("reqstNo"));
            outScanMap.put("pFromLocId", params.get("fromLocId"));
            outScanMap.put("pTrnscType", "AD_MOBILE_CHECK");//CHECK
            outScanMap.put("pUserId", params.get("userId"));
            barcodeRegisterApiMapper.adMobileCheckBarcode(outScanMap);

            barcodeRegisterApiForm.setErrcode((String)outScanMap.get("errcode"));
            barcodeRegisterApiForm.setErrmsg((String)outScanMap.get("errmsg"));
            if( barcodeRegisterApiForm.getErrcode().equals("000") == false){
                throw new ApplicationException(AppConstants.FAIL, barcodeRegisterApiForm.getErrmsg());
            }
            List<BarcodeRegisterApiForm> rtn = new ArrayList<BarcodeRegisterApiForm>();
            rtn.add(barcodeRegisterApiForm);
            return rtn;
        }else{
            throw new ApplicationException(AppConstants.FAIL, "serialNo value does not exist.");
        }
    }

    /**
	 * selectBarcodeByBox
	 * @Author MY-HLTANG
	 * @Date 2021. 11. 24.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
    @Override
    public List<EgovMap> selectBarcodeByBox(Map<String, Object> params) throws Exception {

    	return barcodeRegisterApiMapper.selectBarcodeByBox(params);
	}
}
