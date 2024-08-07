package com.coway.trust.biz.logistics.barcodeRegister.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : BarcodeRegisterApiMapper.java
 * @Description : 바코드 등록 Api Mapper
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 17.   KR-HAN        First creation
 * </pre>
 */
@Mapper("barcodeRegisterApiMapper")
public interface BarcodeRegisterApiMapper {

	 /**
	 * 바코드 등록 리스트
	 * @Author KR-HAN
	 * @Date 2019. 12. 17.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBarcodeRegisterList(Map<String, Object> params);

	 /**
	 * 바코드 등록
	 * @Author KR-HAN
	 * @Date 2019. 12. 23.
	 * @param formMap
	 */
	void saveBarcodeScan(Map<String, Object> formMap);

	 /**
	 * 바코드 삭제
	 * @Author KR-HAN
	 * @Date 2019. 12. 23.
	 * @param formMap
	 */
	void deleteBarcode(Map<String, Object> formMap);

    /**
    * 모바일 AD 바코드 체크
    * @Author KR-KangJaeMin
    * @Date 2019. 12. 31.
    * @param formMap
    */
   void adMobileCheckBarcode(Map<String, Object> formMap);

   /**
    * selectBarcodeByBox
    * @Author MY-HLTANG
    * @Date 2021. 11. 24.
    * @param formMap
    */
   List<EgovMap> selectBarcodeByBox(Map<String, Object> params);

}
