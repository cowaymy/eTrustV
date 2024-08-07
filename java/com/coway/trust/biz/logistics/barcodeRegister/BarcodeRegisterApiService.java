package com.coway.trust.biz.logistics.barcodeRegister;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.barcodeRegister.BarcodeRegisterApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : BarcodeRegisterApiService.java
 * @Description : 바코드 등록 API Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 17.   KR-HAN        First creation
 * </pre>
 */
public interface BarcodeRegisterApiService {

	 /**
	 * 바코드 등록 리스트
	 * @Author KR-HAN
	 * @Date 2019. 12. 17.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBarcodeRegisterList(Map<String, Object> params);

	 /**
	 * saveBarcode
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
	void saveBarcode(BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception;

	 /**
	 * deleteBarcode
	 * @Author KR-HAN
	 * @Date 2019. 12. 19.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
	void deleteBarcode(BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception;

    /**
    * AD_MOBILE_CHECK(Audit Mobile Check)
    * @Author KR-KangJaeMin
    * @Date 2019. 12. 31.
    * @param barcodeRegisterApiForm
    * @throws Exception
    */
	List<BarcodeRegisterApiForm> adMobileCheckBarcode(BarcodeRegisterApiForm barcodeRegisterApiForm) throws Exception;

	/**
	 * selectBarcodeByBox
	 * @Author MY-HLTANG
	 * @Date 2021. 11. 24.
	 * @param barcodeRegisterApiForm
	 * @throws Exception
	 */
	List<EgovMap> selectBarcodeByBox(Map<String, Object> params) throws Exception;
}
