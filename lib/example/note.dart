/*






ทำให้ Widget ขึ้นบรรทัดใหม่ได้โดยไม่ต้องกำหนด c width
Wrap(
  crossAxisAlignment: WrapCrossAlignment.center,
  children: <Widget>
)



ขึ้นบรรทัดใหม่ ให้ Widget ของ Text
double c_width = MediaQuery.of(context).size.width * 0.7;
Container(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    width: c_width,
)



 */
