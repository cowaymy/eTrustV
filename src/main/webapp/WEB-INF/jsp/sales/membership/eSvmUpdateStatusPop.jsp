<article class="tap_area"><!-- tap_area start -->
<aside class="title_line"><!-- title_line start -->
<h3>Update Status</h3>
</aside><!-- title_line end -->
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" id="SARefNo_header">SA Reference No<span class="must">*</span></th>
    <td><input type="text" title="" id="SARefNo" name="SARefNo" placeholder="Key-in by Admin" class="w100p" /></td>
    <th scope="row">Purchase Order<span class="must">*</span></th>
    <td><input type="text" title="" id="PONo" name="PONo" placeholder="Key-in by Admin" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Action<span class="must">*</span></th>
    <td colspan='3'>
         <select class="w100p"  id="action" name="action" onchange="fn_displaySpecialInst()">
            <option value="5">Approved</option>
            <option value="6">Rejected</option>
            <option value="1">Active</option>
        </select>
    </td>
</tr>

<tr id="specInst">
    <th scope="row" id="specialInst_header"><span>Special Instruction</span></th>
    <td colspan='3'>
    <select id="specialInstruction" name="specialInstruction" class="w100p" >
        <c:forEach var="list" items="${specialInstruction}" varStatus="status">
               <option value="${list.code}">${list.codeDesc}</option>
        </c:forEach>
    </select></td>
</tr>
<tr>
    <th scope="row">Others Remark</th>
    <td colspan='3'>
        <textarea cols="40" rows="5"  id="remark" name="remark" placeholder="Others Remark" maxlength="1000"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->