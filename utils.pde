PVector compute_normal(float u1, float u2, float u3, float v1, float v2, float v3)
{
	return new PVector(
		u2*v3-u3*v2,
		u3*v1-u1*v3,
		u1*v2-u2*v1
	);
}