package com.coway.trust.biz.eAccounting.creditCard;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface CreditCardApplication {
	
	void insertCreditCardBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateCreditCardBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void removeCreditCardBiz(Map<String, Object> params);
	
	void insertReimbursementAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateReimbursementAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void deleteReimbursementAttachBiz(FileType type, Map<String, Object> params);
	

}
