package com.coway.trust.biz.eAccounting.pettyCash;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;


public interface PettyCashApplication {
	
	Boolean insertCustodianBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateCustodianBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void deleteCustodianBiz(FileType type, Map<String, Object> params);
	
	void insertPettyCashReqstBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updatePettyCashReqstBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void insertPettyCashAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updatePettyCashAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void deletePettyCashAttachBiz(FileType type, Map<String, Object> params);

}
