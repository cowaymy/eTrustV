<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Attachment</h3>
</aside><!-- title_line end -->


<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:350px" />
    <col style="width:*" />
</colgroup>
<tbody id="attchFrm">
<tr>
    <th scope="row">Card Image <span class="must">*</span></th>
    <td>
        <div class='auto_file2 auto_file3'>
            <input type='file' title='file add'  id='cardImageFile' accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='cardImageFileTxt'  name=''/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a></span>
                </c:if>
            </label>
			 </div>
    </td>
</tr>
<tr>
    <th scope="row">3rd Party Letter <span class="must optionalStar2">*</span</th>
    <td>
        <div class='auto_file2 auto_file3'>
            <input type='file' title='file add'  id='otherFile1' accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='otherFileTxt1'/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a>
                </c:if>
            </label>
            <c:if test="${authFuncChange == 'Y'}">
            <span class="optional2"><span class='label_text attach_mod remove_btn'><a href='#' onclick='fn_removeFile("OTH1")'>Remove</a></span>
                </c:if>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">3rd Party NRIC Copy <span class="must optionalStar3">*</span</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile2" accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='otherFileTxt2'/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a></span>
                </c:if>
             </label>
             <c:if test="${authFuncChange == 'Y'}">
             <span class="optional3"><span class='label_text attach_mod remove_btn'><a href='#' onclick='fn_removeFile("OTH2")'>Remove</a></span>
                </c:if>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Business Registration Form Copy <span class="must optionalStar4">*</span</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile3" accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='otherFileTxt3'/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a></span>
                </c:if>
            </label>
            <c:if test="${authFuncChange == 'Y'}">
            <span class="optional4"><span class='label_text attach_mod remove_btn'><a href='#' onclick='fn_removeFile("OTH3")'>Remove</a></span>
                </c:if>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Other 1</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile4" accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='otherFileTxt4'/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a></span>
                </c:if>
            </label>
            <c:if test="${authFuncChange == 'Y'}">
            <span class='label_text attach_mod remove_btn'><a href='#' onclick='fn_removeFile("OTH4")'>Remove</a></span>
                </c:if>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Other 2</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile5" accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='otherFileTxt5'/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a></span>
                </c:if>
            </label>
            <c:if test="${authFuncChange == 'Y'}">
            <span class='label_text attach_mod remove_btn'><a href='#' onclick='fn_removeFile("OTH5")'>Remove</a></span>
                </c:if>
        </div>
    </td>
</tr>
<tr>
    <th scope="row">Other 3</th>
    <td>
        <div class="auto_file2 auto_file3">
            <input type="file" title="file add" id="otherFile6" accept="image/*"/>
            <label>
                <input type='text' class='input_text' readonly='readonly' id='otherFileTxt6'/>
                <c:if test="${authFuncChange == 'Y'}">
                <span class='label_text attach_mod upload_btn'><a href='#'>Upload</a></span>
                </c:if>
            </label>
            <c:if test="${authFuncChange == 'Y'}">
            <span class='label_text attach_mod remove_btn'><a href='#' onclick='fn_removeFile("OTH6")'>Remove</a></span>
                </c:if>
        </div>
    </td>
</tr>
<tr>
    <td colspan=2><span class="red_text">Only allow picture format (JPG, PNG, JPEG)</span></td>
</tr>
</tbody>
</table>

</article><!-- tap_area end -->