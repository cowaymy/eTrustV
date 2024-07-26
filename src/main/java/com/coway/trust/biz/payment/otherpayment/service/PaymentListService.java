package com.coway.trust.biz.payment.otherpayment.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PaymentListService
{


	/**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectGroupPaymentList(Map<String, Object> params);

    /**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectPaymentListByGroupSeq(Map<String, Object> params);

    /**
   	 * Payment List 조회
   	 * @param
   	 * @param params
   	 * @param model
   	 * @return
   	 */
       List<EgovMap> selectRequestDCFByGroupSeq(Map<String, Object> params);

    int invalidReverse(Map<String, Object> params);

    int invalidDCF(Map<String, Object> params);

    int invalidFT(Map<String, Object> params);

    /**
	 * Payment List - Request DCF 정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap selectReqDcfInfo(Map<String, Object> params);

    /**
	 * Payment List - Request DCF
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap requestDCF(Map<String, Object> params);

    /**
	 * Payment List - Request DCF 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectRequestDCFList(Map<String, Object> params);

    /**
	 * Payment List - Reject DCF
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    void rejectDCF(Map<String, Object> params);

    /**
	 * Payment List - Approval DCF 처리
	 * @param params
	 * @param model
	 * @return
	 */
    Map<String, Object> approvalDCF(Map<String, Object> params);

    /**
	 * Payment List 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectFTOldData(Map<String, Object> params);

    /**
	 * Request Fund Transfer
	 * @param Map
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap requestFT(Map<String, Object> paramMap, List<Object> paramList );

    /**
	 * Payment List - Request FT 리스트 조회
	 * @param params
	 * @param model
	 * @return
	 */
    List<EgovMap> selectRequestFTList(Map<String, Object> params);

    /**
	 * Payment List - Request FT 상세정보 조회
	 * @param params
	 * @param model
	 * @return
	 */
    EgovMap selectReqFTInfo(Map<String, Object> params);

    /**
	 * Payment List - Reject FT
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
    void rejectFT(Map<String, Object> params);

    /**
	 * Payment List - Approval FT 처리
	 * @param params
	 * @param model
	 * @return
	 */
    int approvalFT(Map<String, Object> params);

    /* CELESTE 20230306 [S] */
    void insertAttachment(List<FileVO> list, FileType type, Map<String, Object> params);
    List<EgovMap> selectRefundOldData(Map<String, Object> params);
    int invalidRefund(Map<String, Object> params);
    int invalidStatus(Map<String, Object> params);
    List<EgovMap> selectInvalidORType(Map<String, Object> params);
    EgovMap requestRefund(Map<String, Object> paramMap, List<Object> paramList, List<Object> apprList );
    List<EgovMap> selectRequestRefundList(Map<String, Object> params);
    List<EgovMap> selectRequestRefundByGroupSeq(Map<String, Object> params);
    EgovMap selectReqRefundInfo(Map<String, Object> params);
    List<EgovMap> selectReqRefundApprovalItem(Map<String, Object> params);
    Map<String, Object> approvalRefund(Map<String, Object> params);
    void rejectRefund(Map<String, Object> params);
    EgovMap selectAttachmentInfo(Map<String, Object> params);
    EgovMap selectAllowFlg(Map<String, Object> params);
    /* CELESTE 20230306 [E] */

    /* BOI DCF*/
    EgovMap selectReqDcfNewInfo(Map<String, Object> params);
    List<EgovMap> selectReqDcfNewAppv(Map<String, Object> params);
    List<EgovMap> selectRequestNewDCFByGroupSeq(Map<String, Object> params);
    EgovMap selectDcfInfo(Map<String, Object> params);
    void rejectNewDCF(Map<String, Object> params);
    Map<String, Object> approvalNewDCF(Map<String, Object> params);
    void insertRequestDcfAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
    EgovMap requestDCF2(Map<String, Object> params) throws JsonParseException, JsonMappingException, IOException;
    EgovMap checkBankStateMapStus(Map<String, Object> params);
    /* [END] BOI DCF*/
    List<EgovMap> selectRefundCodeList(Map<String, Object> params);
    List<EgovMap> selectBankListCode();
	List<EgovMap> selectInvalidORCodeNm(Map<String, Object> params);
}
