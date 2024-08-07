package com.coway.trust.biz.supplement;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface SupplementSubmissionApplication {

  void insertSupplementSubmissionAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

  void updateSupplementSubmissionAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

}
